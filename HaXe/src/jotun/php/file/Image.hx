package jotun.php.file;
import php.Lib;
import php.NativeArray;
import jotun.tools.Key;
import sys.FileSystem;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Image implements IImage {
	
	/**
	 * Image file
	 */
	private var _res:Dynamic;

	/**
	 * Current image name
	 */
	public var name:String;
	
	/**
	 * Current image width
	 */
	public var width:Int;
	
	/**
	 * Current image height
	 */
	public var height:Int;
	
	/**
	 * File Type
	 */
	public var type:Int;
	
	public function getExtension():String {
		switch(type){
			case 1 : return 'gif';
			case 2 : return 'jpg';
			case 3 : return 'png';
			case 6 : return 'bmp';
		}
		return null;
	}
	
	private function _update(resource:Dynamic):Void {
		dispose();
		_res = resource;
		width = php.Syntax.codeDeref('imagesx({0})', _res);
		height = php.Syntax.codeDeref('imagesy({0})', _res);
	}
	
	/**
	 * Create a image manipulator object
	 * @param	file
	 */
	public function new(?file:Dynamic) {
		if (file != null){
			open(file);
		}
	}
	
	/**
	 * Open file for location or data string
	 * @param	file
	 * @return
	 */
	public function open(file:Dynamic):IImage {
		dispose();
		if (file != null) {
			// Check if is file
			var isFile:Bool = php.Syntax.codeDeref('is_file({0})', file);
			var img:Dynamic = null;
			if (isFile) {
				name = file;
				var info:NativeArray = php.Syntax.codeDeref('getimagesize({0})', file);
				width = info[0];
				height = info[1];
				type = info[2];
				switch(type) {
					case 1 : img = php.Syntax.codeDeref('imagecreatefromgif({0})', file);
					case 2 : img = php.Syntax.codeDeref('imagecreatefromjpeg({0})', file);
					case 3 : img = php.Syntax.codeDeref('imagecreatefrompng({0})', file);
					case 6 : img = php.Syntax.codeDeref('imagecreatefromwbmp({0})', file);
				}
			}else {
				img = php.Syntax.codeDeref('imagecreatefromstring({0})', file);
				width = php.Syntax.codeDeref('imagesx({0})', _res);
				height = php.Syntax.codeDeref('imagesy({0})', _res);
			}
			_res = img;
		}
		return this;
	}
	
	/**
	 * Change image size
	 * @param	width
	 * @param	height
	 * @param	ratio
	 * @return
	 */
	public function resample(width:Int, height:Int, ?ratio:Bool = true):IImage {
		if (isValid()) {
			if (ratio) {
				if (height >= width){
					width = Math.round(height / this.height * this.width);
				} else{
					height = Math.round(width / this.width * this.height);
				}
			}
			var newimg:Dynamic = php.Syntax.codeDeref('imagecreatetruecolor({0},{1})', width, height);
			// Transparency
			if (newimg != null) {
				php.Syntax.codeDeref('imagealphablending({0},{1})', newimg, false);
				php.Syntax.codeDeref('imagesavealpha({0},{1})', newimg, true);
				var alpha:Dynamic = php.Syntax.codeDeref('imagecolorallocatealpha({0},{1},{2},{3},{4})', newimg, 255, 255, 255, 127);
				php.Syntax.codeDeref('imagefilledrectangle({0},{1},{2},{3},{4},{5})', newimg, 0, 0, width, height, alpha);
				php.Syntax.codeDeref('imagecopyresampled({0},{1},{2},{3},{4},{5},{6},{7},{8},{9})', newimg, _res, 0, 0, 0, 0, width, height, this.width, this.height);
				_update(newimg);
			}
		}
		return this;
	}
	
	/**
	 * Crop image on coordinates
	 * @param	x
	 * @param	y
	 * @param	width
	 * @param	height
	 * @return
	 */
	public function crop(x:Int, y:Int, width:Int, height:Int):IImage {
		if(isValid()){
			// Check position
			if (x < 0){
				x = 0;
			}
			if (y < 0){
				y = 0;
			}
			var tx:Int = x + width;
			var ty:Int = y + width;
			// Check dimension
			if (tx > this.width){
				tx = this.width;
			}
			if (ty > this.height){
				ty = this.height;
			}
			// Apply crop to image
			//trace(x, y, width, height);
			var newimg:Dynamic = php.Syntax.codeDeref('imagecreatetruecolor({0},{1})', width, height);
			if (newimg != null) {
				php.Syntax.codeDeref('imagecopy({0},{1},{2},{3},{4},{5},{6},{7})', newimg, _res, x, y, 0, 0, tx, ty);
				_update(newimg);
			}
		}
        return this;
	}
	
	/**
	 * Ffit image to size
	 * @param	width
	 * @param	height
	 * @return
	 */
	public function fit(width:Int, height:Int):IImage {
		if (isValid()) {
			var ow:Int = this.width;
			var oh:Int = this.height;
			// Resample to min scale
			if (ow >= oh){
				resample(Math.round(width/ow * height), height, true);
			} else{
				resample(width, Math.round(height/oh * width), true);
			}
		}
		return this;
	}
	
	public function isOutBounds(width:Int, height:Int):Bool {
		return (this.width <= width && this.height <= height) == false;
	}
	
	/**
	 * Save modified file
	 * @param	name
	 * @param	type
	 * @return
	 */
	public function save(?name:String, ?type:Dynamic, ?quality:Int):Bool {
		if(isValid()){
			if (type == null){
				type = this.type;
			}
			if (name == null){
				name = this.name;
			}
			try {
				switch(type) {
					case 1, "gif", "GIF" : php.Syntax.codeDeref('imagegif({0},{1})', _res, name);
					case 3, "png", "PNG" : php.Syntax.codeDeref('imagepng({0},{1})', _res, name);
					case 6, "wbmp", "WBMP" : php.Syntax.codeDeref('imagewbmp({0},{1})', _res, name);
					default : php.Syntax.codeDeref('imagejpeg({0},{1},{2})', _res, name, quality != null ? quality : 90);
				}
				return true;
			} catch (e:Dynamic) {
			}
		}
		return false;
	}
	
	public function delete():Void {
		FileSystem.deleteFile(name);
	}
	
	public function dispose():Void {
		if (_res != null){
			php.Syntax.codeDeref('imagedestroy({0})', _res);
		}
		_res = null;
	}
	
	/**
	 * Check if resource is valid
	 * @return
	 */
	public function isValid():Bool {
		return _res != null;
	}
	
}