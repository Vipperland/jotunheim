package jotun.transitions;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Ease")

class Ease {
	
	private static function _F(n:Dynamic):IEasing {
		n = untyped __js__("window[n];");
		return cast n != null ? { x:n.easeNone, I:n.easeIn, O:n.easeOut, IO:n.easeInOut, OI:n.easeOutIn } : { };
	}
	
	public static var LINEAR:IEasing;
	public static var CIRC:IEasing;
	public static var CUBIC:IEasing;
	public static var QUAD:IEasing;
	public static var EXPO:IEasing;
	public static var BACK:IEasing;
	public static var ELASTIC:IEasing;
	public static var QUART:IEasing;
	public static var QUINT:IEasing;
	
	public static function update():Void {
		LINEAR = _F("Linear");
		CIRC = _F("Circ");
		CUBIC = _F("Cubic");
		QUAD = _F("Quad");
		EXPO = _F("Expo");
		BACK = _F("Back");
		ELASTIC = _F("Elastic");
		QUART = _F("Quart");
		QUINT = _F("Quint");
	}
	
	public static function fromString(q:String):Dynamic {
		var q:Array<String> = [];
		var C:IEasing = Reflect.field(Ease, q[0]);
		var e:Dynamic = null;
		if (C != null) {
			if (q.length > 1) e = Reflect.field(C, q[1]);
			if (e == null)	e = C.X;
			return e;
		}
		return LINEAR.X;
	}
	
}