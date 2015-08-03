package sirius.math;
import haxe.Log;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class ARGB{
	
	public var a:Int;
	public var r:Int;
	public var g:Int;
	public var b:Int;
	
	public function new(q:Dynamic, ?g:Int, ?b:Int, ?a:Int) {
		
		var s:Bool = Std.is(q, String) && (q.substr(0,3) == "rgb" ||  q.substr(0, 2) == "0x" || q.substr(0, 1) == "#");
		
		if (s && q.substr(0, 3) == "rgb") {
			s = false;
			q = q.split("rgb").join("").split("(").join("").split(")").join("").split(" ").join("");
			q = q.split(",");
			b = Std.parseInt(q[2]);
			g = Std.parseInt(q[1]);
			q = Std.parseInt(q[0]);
			
		}
		
		if (!s && q <= 0xFF) {
			this.a = a <= 0xFF ? (a < 0 ? 0 : a) : 0xFF;
			this.r = q <= 0xFF ? (q < 0 ? 0 : q) : 0xFF;
			this.g = g <= 0xFF ? (g < 0 ? 0 : g) : 0xFF;
			this.b = b <= 0xFF ? (b < 0 ? 0 : b) : 0xFF;
		}else {
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
		
		if (a == 0) a = 0xFF;
		
	}
	
	public function value32():Int {
		return a << 24 | r << 16 | g << 8 | b;
	}
	
	public function value():Int {
		return r << 16 | g << 8 | b;
	}
	
	public function invert():ARGB {
		return new ARGB(255-r, 255-g, 255-b, a);
	}
	
	public function range(rate:Float, ?alpha:Float=0):ARGB {
		if (rate < .01) rate = .01;
		var r2:Int = Std.int((r == 0 ? 1 : r) * rate);
		var g2:Int = Std.int((g == 0 ? 1 : g) * rate);
		var b2:Int = Std.int((b == 0 ? 1 : b) * rate);
		return new ARGB(r2 > 0xFF ? 0xFF : r2, g2 > 0xFF ? 0xFF : g2, b2 > 0xFF ? 0xFF : b2, alpha == 0 ? a : Std.int(alpha * a));
	}
	
	public function change(ammount:Int):ARGB {
		var r2:Int = r + ammount;
		var g2:Int = g + ammount;
		var b2:Int = b + ammount;
		return new ARGB(r2 > 0xFF ? 0xFF : r2, g2 > 0xFF ? 0xFF : g2, b2 > 0xFF ? 0xFF : b2, a);
	}
	
	public function hex():String {
		var r:String = untyped __js__("this.value().toString(16)");
		while (r.length < 6) r = "0" + r;
		return "#" + r;
	}
	
	public function css():String {
		return "rgb(" + r + "," + g + "," + b + "," + a + ")";
	}
	
}