package sirius.php.file;
import haxe.io.Bytes;
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
	
	public static var files:Array<FileInfo> = [];
	
	public static var savePathImg:String = 'uploads/images/';
	
	public static var savePathDoc:String = 'uploads/documents/';
	
	public static var maxWidth:UInt = 1920;
	
	public static var maxHeight:UInt = 1080;
	
	public static var sizes:Dynamic = null;
	
	public static function set(imgPath:String, ?docPath:String, ?width:UInt, ?height:UInt):Void {
		savePathImg = imgPath;
		if (docPath != null)
			savePathDoc = docPath;
		if (width != null)
			maxWidth = width;
		if (height != null)
			maxHeight = height;
	}
	
	public static function save(?thumb:Dynamic):Array<FileInfo> {
		if (thumb != null){
			if(!Std.is(thumb, Array))
				sizes = [thumb];
			else
				sizes = thumb;
			Dice.All(sizes, function(p:Dynamic, v:Dynamic){
				if (!Std.is(v, Array)){
					v = [v, v];
				}else if(v.length == 1){
					v[1] = v[0];
				}
				sizes[p] = v;
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
							var nName:String = Key.GEN(8) + '-' + Sirius.tick + '.' + name.split(".").pop();
							// save file to disk
							fileStream = File.write(_getSavePath(nName), true);
							files[files.length] = new FileInfo(type, name, nName);
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
		
		// Initiate image editor
		var image:Image = new Image();
		
		// Iterate all "image" type files
		Dice.Values(files, function(v:FileInfo) {
			if (v.type == "image") {
				var p:String = savePathImg + v.output;
				image.open(p);
				// AWAYS resample image, for disk space optimization
				image.resample(maxWidth, maxHeight, true);
				image.save();
				// Generate THUMB for image
				Dice.Values(sizes, function(v1:Dynamic){
					image.fit(v1[0], v1[1], true);
					image.save(savePathImg + 'thumb/' + v.output);
				});
			}
		});
		
	}
	
}