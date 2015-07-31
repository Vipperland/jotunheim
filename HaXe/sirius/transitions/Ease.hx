package sirius.transitions;

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
	
	public static var LINEAR:IEasing = _F("Linear");
	public static var CIRC:IEasing = _F("Circ");
	public static var CUBIC:IEasing = _F("Cubic");
	public static var QUAD:IEasing = _F("Quad");
	public static var EXPO:IEasing = _F("Expo");
	public static var BACK:IEasing = _F("Back");
	public static var ELASTIC:IEasing = _F("Elastic");
	public static var QUART:IEasing = _F("Quart");
	public static var QUINT:IEasing = _F("Quint");
	
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