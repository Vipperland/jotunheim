package sirius.tools;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("Ticker")
class Ticker {
	
	private static var _uid:Int;
	
	private static var _pool:Array<Dynamic> = [];
	
	private static function _tickAll():Void {
		var order:Int = 0;
		Dice.All(_pool, function(p:Int, v:Dynamic) {
			if (v != null) {
				v();
				if (order < p) _pool[order] = v;
				++order;
			}
		});
	}
	
	public static function init():Void {
		stop();
		var t:Dynamic = _tickAll;
		_uid = untyped __js__("setInterval(t,33)");
	}
	
	public static function stop():Void {
		var uid:Int = _uid;
		untyped __js__("clearInterval(uid)");
	}
	
	public static function add(handler:Dynamic):Void {
		if (handler == null) return;
		var iof:Int = _pool.indexOf(handler);
		if (iof == -1) _pool[_pool.length] = handler;
	}
	
	public static function remove(handler:Dynamic):Void {
		if (handler == null) return;
		var iof:Int = _pool.indexOf(handler);
		if (iof != -1) _pool[iof] = null;
	}
	
}