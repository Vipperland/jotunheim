package jotun.php.file;
import haxe.io.Bytes;
import jotun.Jotun;
import php.Lib;
import php.Web;
import jotun.tools.Key;
import jotun.tools.Utils;
import jotun.utils.Dice;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Uploader {
	
	public static var files:FileCollection = new FileCollection();

	private static var _sizes:Dynamic;
	
	private static var _path:String = '/';

	
	public static function createPath(q:String):Void {
		var p:String = '';
		Dice.Values(q.split('/'), function(v:String){
			if(v.length > 0){
				p += v;
				if (!FileSystem.exists(p) || !FileSystem.isDirectory(p)){
					untyped __call__("mkdir", p, untyped __php__('0777'));
				}
				p += '/';
			}
		});
	}
	
	public static function save(path:String, ?sizes:Dynamic):FileCollection {
		
		if (_path != path){
			createPath(path);
			_path = path;
		}
		
		if (sizes != null){
			_sizes = sizes;
		}
		_verify();
		return files;
	}
	
	static private function _getType(file:String):String {
		var ext:String = file.split(".").pop().toLowerCase();
		switch (ext) {
			case "jpg", "jpeg", "png", "gif" : return "image";
			default : return "document";
		}
	}
	
	static private function _verify() {
		
		var partName:String = null;
		var lastFile:String = null;
		var fileStream:FileOutput = null;
		
		// Get all form data
		Web.parseMultipart(
			function(part:String, name:String):Void {
				// Save only specified files to disk and skip form params
				if (Utils.isValid(name)) {
					if (name != null && lastFile != name) {
						partName = part;
						lastFile = name;
						// Close current stream
						if (fileStream != null){
							fileStream.close();
						}
						// Get file type
						var type:String = _getType(name);
						if (type != null) {
							// Generate new filename
							var nName:String = Jotun.tick + '_' + Key.GEN(8) + '.' + name.split(".").pop();
							// save file to disk
							fileStream = File.write(_path + nName, true);
							files.add(part, new FileInfo(type, name, nName));
						}
					}
				}else {
					fileStream = null;
				}
			},
			function(bytes:Bytes, pos:Int, len:Int):Void {
				// Write current file bytes
				if (fileStream != null){
					fileStream.writeBytes(bytes, 0, bytes.length);
				}
			}
		);
		
		// Close any stream
		if (fileStream != null){
			fileStream.close();
		}
		
		// Iterate all "image" type files
		if (_sizes != null){
			var image:IImage = new Image();
			Dice.Values(files.list, function(v:FileInfo) {
				if (v.type == "image") {
					v.sizes = [];
					Dice.All(_sizes, function(p:String, s:Dynamic){
						var o:String = _path + v.output;
						image.open(o);
						if (image.isOutBounds(s.width, s.height)){
							// Create a copy with new size
							image.fit(s.width, s.height);
							o = _rename(o, p);
							image.save(o);
							v.sizes.push(o);
						}else if (s.create){
							// Create a copy if size is smaller
							o = _rename(o, p);
							image.save(o);
							v.sizes.push(o);
						}
					});
					if (v.sizes != null){
						v.output = null;
						image.delete();
					}
				}
			});
		}
		
	}
	
	private static function _rename(o:String, p:String):String {
		var n:Array<String> = o.split('.');
		n[n.length - 1] = p + '.' + n.pop();
		return n.join('.');
	}
	
}