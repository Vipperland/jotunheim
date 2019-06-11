package jotun.php.file;
import php.Lib;
import jotun.math.IPoint;
import jotun.math.Point;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class ImageLib {
	
	public var content:Array<IImage>;
	
	public function new(files:Dynamic) {
		content = [];
		// Oen files if not null
		if (files != null)
			open(files);
	}
	
	public function open(files:Dynamic):ImageLib {
		// Convert string to array
		if (!Std.is(files, Array))
			files = [files];
		// Buffer all files
		Dice.Values(files, function(v:Dynamic) {
			var img:IImage = new Image(v);
			if(img.isValid())
				content[content.length] = img;
		});
		
		return this;
	}
	
	public function resample(width:UInt, height:UInt, ?ratio:Bool = true):ImageLib {
		Dice.Values(content, function(v:IImage) { v.resample(width, height, ratio); });
		return this;
	}
	
	public function multisample(sizes:Array<IPoint>):ImageLib {
		Dice.Values(sizes, function(v:IPoint) { 
			resample(Std.int(v.x), Std.int(v.y), true);
		});
		return this;
	}
	
	public function crop(x:UInt, y:UInt, width:UInt, height:UInt):ImageLib {
		Dice.Values(content, function(v:IImage) { v.crop(x, y, width, height); });
		return this;
	}
	
	public function fit(width:UInt, height:UInt):ImageLib {
		Dice.Values(content, function(v:IImage) { v.fit(width, height); });
		return this;
	}
	
	public function save(?type:UInt):ImageLib {
		Dice.Values(content, function(v:IImage) { v.save(null, type); });
		return this;
	}
	
}