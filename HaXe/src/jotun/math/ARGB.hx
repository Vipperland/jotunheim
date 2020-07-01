package jotun.math;
import haxe.Log;
import jotun.math.IARGB;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose('ARGB')
class ARGB implements IARGB {
	
	public static function from(q:Dynamic, ?g:Int, ?b:Int, ?a:Int):IARGB {
		return new ARGB(q, g, b, a);
	}
	
	private static function _minmax(q:Float):Int {
		return q < 0 ? 0 : q > 0xFF ? 0xFF : (cast q) >> 0;
	}
	
	public var a:Int;
	public var r:Int;
	public var g:Int;
	public var b:Int;
	
	private static function _v16(v:Int):String {
		var a:String = js.Syntax.code('v.toString({0})', 16);
		return a.length == 1 ? '0' + a : a;
	}
	
	public function new(q:Dynamic, ?g:Int, ?b:Int, ?a:Int) {
		
		// rgb(0,0,0[,0]), 0x000000, #000000
		var s:Bool = Std.is(q, String) && (q.substr(0,3) == "rgb" || q.substr(0, 2) == "0x" || q.substr(0, 1) == "#");
		
		// rgb(R,G,B[,A])
		if (s && q.substr(0, 3) == "rgb") {
			s = false;
			q = q.split(q.substr(0,4) == "rgba" ? "rgba" : "rgb")[1].split("(").join("").split(")").join("").split(" ").join("");
			q = q.split(",");
			if (q.length == 4) {
				a = Std.parseInt(q[3]);
			}
			b = Std.parseInt(q[2]);
			g = Std.parseInt(q[1]);
			q = Std.parseInt(q[0]);
		}
		
		//q is INT and g NOT NULL
		if (!s && q <= 0xFF && g != null) {
			this.a = _minmax(a);
			this.r = _minmax(q);
			this.g = _minmax(g);
			this.b = _minmax(b);
		}else {
			// Extract channel values of q
			var x:Int;
			if (s) {	// IF q == #RRGGBB || #AARRGGBB
				q = q.split("#").join("0x");
				x = Std.parseInt(q);
				if (q.length < 10) {
					x = x | 0xFF000000;
				}
			}else {		// IF q is an INT || UINT
				x = q;
			}
			this.a = x >> 24 & 0xFF;
			this.r = x >> 16 & 0xFF;
			this.g = x >> 8 & 0xFF;
			this.b = x & 0xFF;
		}
		
	}
	
	/**
	 * ARGB Color format 24 bits
	 * @return
	 */
	public function value32():Int {
		return a << 24 | r << 16 | g << 8 | b;
	}
	
	/**
	 * RGB Color format 16 bits
	 * @return
	 */
	public function value():Int {
		return r << 16 | g << 8 | b;
	}
	
	/**
	 * Invert each color channel
	 * @return
	 */
	public function invert():IARGB {
		return new ARGB(255-r, 255-g, 255-b, a);
	}
	
	/**
	 * Change color brightnesss
	 * @param	rate
	 * @param	alpha
	 * @return
	 */
	public function multiply(ammount:Float):IARGB {
		if (ammount < .01) {
			ammount = .01;
		}
		return new ARGB(_minmax(r * ammount), _minmax(g * ammount), _minmax(b * ammount), a);
	}
	
	/*
	 * Adds an ammount to each channel at max of 0xFF
	 * @param	ammount
	 * @return
	 */
	public function shift(ammount:Int):IARGB {
		return new ARGB(_minmax(r + ammount), _minmax(g + ammount), _minmax(b + ammount), a);
	}
	
	/**
	 * Hexadecimal representation of the color
	 * Usefull for apply any color styles
	 * @return
	 */
	public function hex():String {
		var r:String = _v16(value());
		while (r.length < 6) {
			r = "0" + r;
		}
		return "#" + r;
	}
	
	/**
	 * CSS string format [rgb(R,G,B,A)]
	 * @return
	 */
	public function css():String {
		if (a == 0xFF || a == null) {
			return "rgb(" + r + "," + g + "," + b + ")";
		}else {
			return "rgba(" + r + "," + g + "," + b + "," + Utils.toFixed(a/255, 2) + ")";
		}
	}
	
}