package sirius.transitions;

/**
 * ...
 * @author Rafael Moreira
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
	
}