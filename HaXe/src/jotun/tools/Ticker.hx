package jotun.tools;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_Ticker")
class Ticker {
	
	private static var _uid:Int;
	
	private static var _pool_high:Array<Float->Void> = [];
	
	private static var _pool_low:Array<Void->Void> = [];
	
	private static var _ltime:Int = 0;
	
	private static var _etime:Float = 0;
	
	private static function _calcElapsed():Void {
		var ctime = js.Syntax.code("Date.now()");
		_etime += (ctime - _ltime) * 0.001;
		_ltime = ctime;
	}
	
	private static function _tickAll():Void {
		_etime = 0;
		Dice.All(_pool_high, function(p:Int, v:Dynamic) {
			if (v != null) {
				_calcElapsed();
				v(_etime);
			}
		});
		while(_etime > 1){
			_etime -= 1.0;
		}
	}
	
	public static function start():Void {
		if(_uid == null){
			stop();
			_ltime = js.Syntax.code("Date.now()");
			_etime = 0;
			_uid = js.Syntax.code("setInterval({0},{1})", _tickAll, 1);
		}
	}
	
	public static function stop():Void {
		js.Syntax.code("clearInterval({0})", _uid);
		_uid = null;
	}
	
	public static function add(handler:Float->Void):Void {
		if (handler == null) {
			return;
		}
		var iof:Int = _pool_high.indexOf(handler);
		if (iof == -1) {
			_pool_high[_pool_high.length] = handler;
		}
	}
	
	public static function addLow(handler:Void->Void):Void {
		if (handler == null) {
			return;
		}
		var iof:Int = _pool_low.indexOf(handler);
		if (iof == -1) {
			_pool_low[_pool_low.length] = handler;
		}
	}
	
	public static function remove(handler:Dynamic):Void {
		if (handler == null) return;
		var iof:Int = _pool_high.indexOf(handler);
		if (iof != -1){
			_pool_high.splice(iof, 1);
		}else{
			iof = _pool_low.indexOf(handler);
			if (iof != -1){
				_pool_low.splice(iof, 1);
			}
		}
	}
	
	public static function delay(handler:Dynamic, time:Float, ?args:Array<Dynamic>):Void {
	}
	
}