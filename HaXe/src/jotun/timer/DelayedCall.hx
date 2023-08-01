package jotun.timer;
import js.Syntax;

/**
 * ...
 * @author Rafael Moreira
 */
class DelayedCall {
	
	var _timer:Timer;
	var _time:Float;
	var _method:Dynamic;
	var _delay:Float;
	var _repeat:Int;
	var _count:Int;
	var _args:Dynamic;
	var _proxy:Dynamic;
	
	private function _exec():Void {
		Reflect.callMethod(null, _method, _args);
	}
	
	private function _tick(time:Float):Void {
		if ((_time += time) >= _delay){
			_time -= _delay;
			_exec();
			if(_count++ >= _repeat){
				cancel();
			}
		}
	}
	
	public function new(timer:Timer, method:Dynamic, delay:Float, repeat:Int, ...args:Dynamic) {
		_repeat = repeat;
		_count = 0;
		_delay = delay * 1000;
		_method = method;
		_timer = timer;
		_time = 0;
		_args = args;
		_proxy = Syntax.code("{0}.bind({1})", _tick, this);
		_timer.add(_proxy);
	}
	
	public function cancel():Void {
		if(_proxy != null && _timer != null){
			_timer.remove(_proxy);
			_proxy = null;
			_timer = null;
			_method = null;
			_args = null;
		}
	}
	
}