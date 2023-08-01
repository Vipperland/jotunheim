package jotun.tools;
import jotun.dom.Display;
import jotun.timer.FrameChannel;
import jotun.utils.Dice;
import js.Syntax;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class DisplayCache {
	
	private var _cache_ctrl:Bool;
	
	private var _cache_time:Int = 0;
	
	private var _cache_delay:Int = 60;
	
	private var _channel:FrameChannel;
	
	private function _clearCache():Void {
		if (++_cache_time >= _cache_delay){
			Display.clearIdles();
			_cache_time = 0;
		}
	}
	
	public function new() {
	}
	
	public function enable(time:Int = 60):Void {
		if(time == null || time < 60){
			time = 60;
		}
		_cache_time = 0;
		_cache_delay = time;
		if (_cache_ctrl != true){
			_cache_ctrl = true;
			if (_channel == null){
				_channel = Jotun.timer.channel(1000);
				Jotun.timer.resume();
			}
			_channel.add(_clearCache);
		}
	}
	
	public function disable():Void {
		if (_cache_ctrl && _channel != null){
			_channel.remove(_clearCache);
		}
	}
	
}