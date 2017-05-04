package sirius.php.file;
import haxe.io.Bytes;
import php.Lib;
import php.Web;
import sirius.tools.Key;
import sirius.tools.Utils;
import sirius.utils.Dice;
import sys.io.File;
import sys.io.FileOutput;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Uploader {
	
	public static var files:FileCollection = new FileCollection();
	
	public static var savePathImg:String = 'upload/images/';
	
	public static var savePathDoc:String = 'upload/documents/';
	
	public static var sizes:Dynamic = [];
	
	public static function set(imgPath:String, ?docPath:String):Void {
		savePathImg = imgPath;
		if (docPath != null)
			savePathDoc = docPath;
	}
	
	public static function save(?optSizes:Array<Dynamic>):FileCollection {
		if (optSizes != null){
			Dice.Values(optSizes, function(v:Dynamic){
				sizes[sizes.length] = Std.is(v, Array) ? {w:v[0],h:v.length==1?v[0]:v[1]} : {w:v,h:v};
			});
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
	
	static private function _getSavePath(type:String, sufix:String = ''):String {
		switch(type) {
			case 'image' : return savePathImg + sufix;
			default : return savePathDoc + sufix;
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
						if (fileStream != null)
							fileStream.close();
						// Get file type
						var type:String = _getType(name);
						if (type != null) {
							// Generate new filename
							var nName:String = 'UID-' + Sirius.tick + '-' + Key.GEN(8) + '.' + name.split(".").pop();
							// save file to disk
							fileStream = File.write(_getSavePath(type, nName), true);
							files.add(part, new FileInfo(type, name, nName));
						}
					}
				}else {
					fileStream = null;
				}
			},
			function(bytes:Bytes, pos:Int, len:Int):Void {
				// Write current file bytes
				if (fileStream != null)
					fileStream.writeBytes(bytes, 0, bytes.length);
			}
		);
		
		// Close any stream
		if (fileStream != null)
			fileStream.close();
		
		// Iterate all "image" type files
		if (sizes.length > 0){
			var image:Image = new Image();
			Dice.Values(files.list, function(v:FileInfo) {
				if (v.type == "image") {
					//try {
						// Generate THUMB for image
						Dice.Values(sizes, function(s:Dynamic){
							var p:String = savePathImg + v.output;
							image.open(p);
							image.save();
							image.fit(s.w, s.h, true);
							var nname:Array<String> = v.output.split('.');
							var ext:String = nname.pop();
							ext = nname.join('.') + '_' + s.w + 'x' + s.h + '.' + ext;
							image.save(savePathImg + ext);
						});
					//}catch(e:Dynamic){
						//v.error = e;
					//}
				}
			});
		}
		
	}
	
}