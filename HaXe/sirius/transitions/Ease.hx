package sirius.transitions;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("Ease")
class Ease {
	
	private static function _F(n:Dynamic):IEasing {
		return cast n != null ? { x:n.easeNone, I:n.easeIn, O:n.easeOut, IO:n.easeInOut, OI:n.easeOutIn } : { };
	}
	
	public static var LINEAR:IEasing = _F(untyped __js__("Linear"));
	public static var CIRC:IEasing = _F(untyped __js__("Circ"));
	public static var CUBIC:IEasing = _F(untyped __js__("Cubic"));
	public static var QUAD:IEasing = _F(untyped __js__("Quad"));
	public static var EXPO:IEasing = _F(untyped __js__("Expo"));
	public static var BACK:IEasing = _F(untyped __js__("Back"));
	public static var ELASTIC:IEasing = _F(untyped __js__("Elastic"));
	public static var QUART:IEasing = _F(untyped __js__("Quart"));
	public static var QUINT:IEasing = _F(untyped __js__("Quint"));
	
}