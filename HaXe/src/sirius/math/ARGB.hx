package sirius.math;
import haxe.Log;
import sirius.math.IARGB;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class ARGB implements IARGB {
	
	public static function from(q:Dynamic, ?g:Int, ?b:Int, ?a:Int):IARGB {
		return new ARGB(q, g, b, a);
	}
	
	public var a:Int;
	public var r:Int;
	public var g:Int;
	public var b:Int;
	
	public function new(q:Dynamic, ?g:Int, ?b:Int, ?a:Int) {
		
		// rgb(0,0,0[,0]), 0x000000, #000000
		var s:Bool = Std.is(q, String) && (q.substr(0,3) == "rgb" ||  q.substr(0, 2) == "0x" || q.substr(0, 1) == "#");
		
		// rgb(R,G,B[,A])
		if (s && q.substr(0, 3) == "rgb") {
			s = false;
			q = q.split("rgba").join("").q.split("rgb").join("").split("(").join("").split(")").join("").split(" ").join("");
			q = q.split(",");
			if (q.length == 4) a = Std.parseInt(q[3]);
			b = Std.parseInt(q[2]);
			g = Std.parseInt(q[1]);
			q = Std.parseInt(q[0]);
			
		}
		
		//q is INT and g NOT NULL
		if (!s && q <= 0xFF && g != null) {
			this.a = a <= 0xFF ? (a < 0 ? 0 : a) : 0xFF;
			this.r = q <= 0xFF ? (q < 0 ? 0 : q) : 0xFF;
			this.g = g <= 0xFF ? (g < 0 ? 0 : g) : 0xFF;
			this.b = b <= 0xFF ? (b < 0 ? 0 : b) : 0xFF;
		}else {
			// Extract channel values of q
			var x:Int;
			if (s) {
				x = Std.parseInt(q.split("#").join("0x"));
			}else {
				x = q;
			}
			this.a = x >> 24 & 0xFF;
			this.r = x >> 16 & 0xFF;
			this.g = x >> 8 & 0xFF;
			this.b = x & 0xFF;
		}
		
		if (a == null) a = 0xFF;
		
	}
	
	/**
	 * ARGB Color format (4bytes/32bits)
	 * @return
	 */
	public function value32():Int {
		return a << 24 | r << 16 | g << 8 | b;
	}
	
	/**
	 * RGB Color format (3bytes/24bits)
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
	 * Raize or diminish color strength by range
	 * @param	rate
	 * @param	alpha
	 * @return
	 */
	public function range(rate:Float, ?alpha:Float=0):IARGB {
		if (rate < .01) rate = .01;
		var r2:Int = Std.int((r == 0 ? 1 : r) * rate);
		var g2:Int = Std.int((g == 0 ? 1 : g) * rate);
		var b2:Int = Std.int((b == 0 ? 1 : b) * rate);
		return new ARGB(r2 > 0xFF ? 0xFF : r2, g2 > 0xFF ? 0xFF : g2, b2 > 0xFF ? 0xFF : b2, alpha == 0 ? a : Std.int(alpha * a));
	}
	
	/**
	 * Adds an ammount to each channel at max of 0xFF
	 * @param	ammount
	 * @return
	 */
	public function change(ammount:Int):IARGB {
		var r2:Int = r + ammount;
		var g2:Int = g + ammount;
		var b2:Int = b + ammount;
		return new ARGB(r2 > 0xFF ? 0xFF : r2, g2 > 0xFF ? 0xFF : g2, b2 > 0xFF ? 0xFF : b2, a);
	}
	
	/**
	 * Hexadecimal representation of the color
	 * Usefull for apply any color styles
	 * @return
	 */
	public function hex():String {
		var r:String = untyped __js__("this.value().toString(16)");
		while (r.length < 6) r = "0" + r;
		return "#" + r;
	}
	
	/**
	 * CSS string format [rgb(R,G,B,A)]
	 * @return
	 */
	public function css():String {
		if (a == 255) {
			return "rgb(" + r + "," + g + "," + b + ")";
		}else {
			return "rgba(" + r + "," + g + "," + b + "," + (cast a/255).toFixed(2) + ")";
		}
	}
	
}