package jotun.tools;
import jotun.dom.Display;
import jotun.utils.Dice;
import js.Syntax;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_Ticker")
class Ticker {
	
	private static var _uid:Int;
	
	private static var _counter:Int = 0;
	
	private static var _pool_high:Array<Float->Void> = [];
	
	private static var _pool_low:Array<Void->Void> = [];
	
	private static var _pool_delayed:Array<IDelayedCall> = [];
	
	private static var _ptime:Float = 0;
	
	private static var _ltime:Float = 0;
	
	private static var _etime:Float = 0;
	
	private static var _cache_ctrl:Bool;
	
	private static var _cache_time:Int = 0;
	
	private static var _cache_delay:Int = 60;
	
	private static function _clearCache():Void {
		if (++_cache_time >= _cache_delay){
			Display.clearIdles();
			_cache_time = 0;
		}
	}
	
	private static function _calcElapsed():Void {
		var ctime = js.Syntax.code("Date.now()");
		_ptime = (ctime - _ltime) * 0.001;
		_etime += _ptime;
		_ltime = ctime;
	}
	
	private static function _tickAll():Void {
		Dice.All(_pool_high, function(p:Int, v:Dynamic) {
			if (v != null) {
				_calcElapsed();
				v(_etime);
			}
		});
		_calcElapsed();
		var shift:Int = 0;
		Dice.All(_pool_delayed, function(p:Int, v:IDelayedCall) {
			if (v != null){
				if(shift < p){
					_pool_delayed[shift] = v;
					_pool_delayed[p] = null;
				}
				v.elapsed += _ptime;
				if (v.elapsed > v.delay){
					v.elapsed -= v.delay;
					++v.ticket.count;
					v.callback(v.ticket);
					if(--v.count <= 0 || v.ticket.cancelled){
						_pool_delayed[p] = null;
					}else{
						++shift;
					}
				}else{
					++shift;
				}
			}
		});
		if (shift < _pool_delayed.length){
			_pool_delayed.splice(shift, _pool_delayed.length);
		}
		_calcElapsed();
		if (_etime >= 1){
			Dice.All(_pool_low, function(p:Int, v:Dynamic) {
				if (v != null) {
					v();
				}
			});
			while(_etime > 1){
				_etime -= 1.0;
			}
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
	
	public static function addHigh(handler:Float->Void):Void {
		if (handler == null) {
			return;
		}
		var iof:Int = _pool_high.indexOf(handler);
		if (iof == -1) {
			_pool_high[_pool_high.length] = handler;
		}
	}
	
	public static function addLower(handler:Void->Void):Void {
		if (handler == null) {
			return;
		}
		var iof:Int = _pool_low.indexOf(handler);
		if (iof == -1) {
			_pool_low[_pool_low.length] = handler;
		}
	}
	
	public static function remove(handler:Dynamic):Void {
		if (handler == null) {
			return;
		}
		if (Std.isOfType(handler, Float)){
			for (i in 0..._pool_delayed.length){
				if (_pool_delayed[i].id == handler){
					_pool_delayed[i] = null;
				}
			}
		}else{
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
		
	}
	
	public static function delay(callback:Dynamic, time:Float, ?count:Int = 1, ?data:Dynamic = null):Int {
		var call:IDelayedCall = cast {
			id: _counter++,
			delay: time,
			elapsed: 0,
			count: count,
			callback: callback,
			ticket: new CallTicket(data),
		}
		_pool_delayed[_pool_delayed.length] = call;
		return call.id;
	}
	
	public static function enableCacheControl(time:Int):Void {
		if(time > 0){
			_cache_delay = time;
		}
		if (_cache_ctrl != true){
			_cache_ctrl = true;
			addLower(_clearCache);
			start();
		}
	}
	
	public static function disableCacheControl():Void {
		if (_cache_ctrl){
			remove(_clearCache);
		}
	}
	
}
private class CallTicket {
	public var data:Dynamic;
	public var cancelled:Bool;
	public var count:Int;
	public function new(data:Dynamic){
		this.data = data;
		this.count = 0;
	}
	public function cancel():Void {
		this.cancelled = true;
	}
}
private interface IDelayedCall {
	public var id:Int;
	public var delay:Float;
	public var elapsed:Float;
	public var count:Int;
	public var callback:CallTicket->Void;
	public var ticket:CallTicket;
}