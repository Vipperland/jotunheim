package jotun.utils;
import js.Browser;
import jotun.dom.Img;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('utils.Pixel')
class Pixel{
	
	static public function isAvailable():Bool {
		return untyped __js__('window.extended != null ? window.extended.CreatePixel != null : false');
	}
	
	static public function Create(color:UInt, opacity:Float):Img {
		var img:Img = new Img();
		if (isAvailable()) {
			var f:Dynamic = untyped __js__('window.extended.CreatePixel');
			img.fit(1, 1);
			img.src(f(color, opacity));
		}
		return img;
	}
	
}