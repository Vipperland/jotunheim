package sirius.tools;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Ticker")
class Ticker {
	
	private static var _uid:Int;
	
	private static var _pool:Array<Dynamic> = [];
	
	private static function _tickAll():Void {
		Dice.All(_pool, function(p:Int, v:Dynamic) {
			if (v != null) v();
		});
	}
	
	public static function start():Void {
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
		if (iof != -1) _pool.splice(iof, 1);
	}
	
	public static function delay(handler:Dynamic, time:Float, ?args:Array<Dynamic>):Delayer {
		return Delayer.create(handler, time, args);
	}
	
}