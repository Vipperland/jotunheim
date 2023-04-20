package jotun.php.file;
import haxe.io.Bytes;
import jotun.Jotun;
import php.Global;
import php.Lib;
import php.SuperGlobal;
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

	private static var _sizes:Array<Dynamic>;
	
	private static var _path:String = '/';
	
	private static var _autoRename:Bool;

	private static var _extensions:Array<String> = ['jpg','gif',null,'png',null,null,'wbmp'];

	
	public static function createPath(q:String):Void {
		var p:String = '';
		Dice.Values(q.split('/'), function(v:String){
			if(v.length > 0){
				p += v + '/';
				if (!FileSystem.exists(p) || !FileSystem.isDirectory(p)){
					php.Syntax.codeDeref("mkdir({0},{1})", p, php.Syntax.codeDeref('0777'));
				}
			}
		});
	}
	
	public static function save(path:String, ?sizes:Array<Dynamic>, ?rename:Bool = true):FileCollection {
		
		_autoRename = rename;
		
		if (_path != path){
			createPath(path);
			_path = path;
		}
		
		if (sizes != null){
			_sizes = sizes;
			Dice.Values(_sizes, function(q:Dynamic){
				if (q.path != null){
					createPath(q.path);
				}
			});
		}
		
		_verify();
		
		return files;
	}
	
	static private function _getType(file:String):String {
		var ext:String = file.split(".").pop().toLowerCase();
		switch (ext) {
			case "jpg", "jpeg", "png", "gif" : 
				return "image";
			default : 
				return "document";
		}
	}
	
	static private function _verify() {
		
		var partName:String = null;
		var lastFile:String = null;
		var fileStream:FileOutput = null;
		
		// Get all form data
		Jotun.domain.parseFiles(
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
							var nName:String = _autoRename ? Jotun.tick + '_' + Key.GEN(8) + '.' + name.split(".").pop() : name;
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
					var delete = false;
					Dice.All(_sizes, function(p:String, s:Dynamic){
						var o:String = _path + v.output;
						image.open(o);
						if (s.create || (s.type != null && v.type != _extensions[s.type])){
							// Create a copy if size is smaller
							if (s.path != null){
								o = s.path + v.output;
							}
							image.fit(s.width, s.height);
							o = _rename(o, s.sufix, _extensions[s.type]);
							if (s.renameFunc != null){
								o = s.renameFunc(o);
							}
							image.save(o, s.type);
							v.sizes.push(o);
						}else if (s.width != null && s.height != null && image.isOutBounds(s.width, s.height)){
							// Create a copy with new size
							image.fit(s.width, s.height);
							o = _rename(o, s.sufix, _extensions[s.type]);
							if (s.renameFunc != null){
								o = s.renameFunc(o);
							}
							image.save(o, s.type);
							v.sizes.push(o);
						}
						if (s.rename){
							if (s.renameFunc != null){
								o = s.renameFunc(o);
							}
							image.save(o);
						}
						if (!delete && s.delete){
							delete = true;
						}
					});
					if (delete){
						v.output = null;
						image.delete();
					}
				}
			});
		}
		
	}
	
	private static function _rename(o:String, p:String, t:String):String {
		var n:Array<String> = o.split('.');
		var e:String = n.pop();
		if (p != null){
			n[n.length] = p;
		}
		n.push(t == null ? e : t);
		return n.join('.');
	}
	
}