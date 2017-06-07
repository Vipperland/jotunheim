package sirius.php.file;
import php.Lib;
import php.NativeArray;
import sirius.tools.Key;
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
	public var width:UInt;
	
	/**
	 * Current image height
	 */
	public var height:UInt;
	
	/**
	 * File Type
	 */
	public var type:UInt;
	
	private function _update(resource:Dynamic):Void {
		dispose();
		_res = resource;
		width = untyped __call__('imagesx', _res);
		height = untyped __call__('imagesy', _res);
	}
	
	/**
	 * Create a image manipulator object
	 * @param	file
	 */
	public function new(?file:Dynamic) {
		if (file != null)
			open(file);
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
			var isFile:Bool = untyped __call__('is_file', file);
			var img:Dynamic = null;
			if (isFile) {
				name = file;
				var info:NativeArray = untyped __call__('getimagesize', file);
				width = info[0];
				height = info[1];
				type = info[2];
				switch(type) {
					case 1 : img = untyped __call__('imagecreatefromgif', file);
					case 2 : img = untyped __call__('imagecreatefromjpeg', file);
					case 3 : img = untyped __call__('imagecreatefrompng', file);
					case 6 : img = untyped __call__('imagecreatefromwbmp', file);
				}
			}else {
				img = untyped __call__('imagecreatefromstring', file);
				width = untyped __call__('imagesx', _res);
				height = untyped __call__('imagesy', _res);
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
	public function resample(width:UInt, height:UInt, ?ratio:Bool = true):IImage {
		if (isValid()) {
			if (ratio) {
				if (height >= width)
					width = Math.round(height / this.height * this.width);
				else
					height = Math.round(width / this.width * this.height);
			}
			var newimg:Dynamic = untyped __call__('imagecreatetruecolor', width, height);
			// Transparency
			if (newimg != null) {
				untyped __call__('imagealphablending', newimg, false);
				untyped __call__('imagesavealpha', newimg, true);
				var alpha:Dynamic = untyped __call__('imagecolorallocatealpha', newimg, 255, 255, 255, 127);
				untyped __call__('imagefilledrectangle', newimg, 0, 0, width, height, alpha);
				untyped __call__('imagecopyresampled', newimg, _res, 0, 0, 0, 0, width, height, this.width, this.height);
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
	public function crop(x:UInt, y:UInt, width:UInt, height:UInt):IImage {
		if(isValid()){
			// Check position
			if (x < 0)
				x = 0;
			if (y < 0)
				y = 0;
			var tx:UInt = x + width;
			var ty:UInt = y + width;
			// Check dimension
			if (tx > this.width)
				tx = this.width;
			if (ty > this.height)
				ty = this.height;
			// Apply crop to image
			//trace(x, y, width, height);
			var newimg:Dynamic = untyped __call__('imagecreatetruecolor', width, height);
			if (newimg != null) {
				untyped __call__('imagecopy', newimg, _res, x, y, 0, 0, tx, ty);
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
	public function fit(width:UInt, height:UInt):IImage {
		if (isValid()) {
			var ow:UInt = this.width;
			var oh:UInt = this.height;
			// Resample to min scale
			if (ow >= oh)
				resample(Math.round(width/ow * height), height, true);
			else
				resample(width, Math.round(height/oh * width), true);
		}
		return this;
	}
	
	/**
	 * Save modified file
	 * @param	name
	 * @param	type
	 * @return
	 */
	public function save(?name:String, ?type:UInt):Bool {
		if(isValid()){
			var dir:String = untyped __call__('dirname', name);
			if (!FileSystem.isDirectory(dir))
				FileSystem.createDirectory(dir);
			if (type == null)
				type = this.type;
			if (name == null)
				name = this.name;
			try {
				switch(type) {
					case 1 : untyped __call__('imagegif', _res, name);
					case 3 : untyped __call__('imagepng', _res, name);
					case 6 : untyped __call__('imagewbmp', _res, name);
					default : untyped __call__('imagejpeg', _res, name, 95);
				}
				return true;
			} catch (e:Dynamic) {
				//Lib.dump(e);
			}
		}
		return false;
	}
	
	public function dispose():Void {
		if (_res != null)
			untyped __call__('imagedestroy', _res);
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