package jotun.timer;
import js.Syntax;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('J_Timer')
class Timer {
	
	private var _paused:Bool;
	private var _channels:Array<FrameChannelProxy>;
	private var _c_channels:Array<FrameChannelProxy>;
	private var _processes:Array<Dynamic>;
	private var _interval:Int;
	private var _length:Int;
	private var _p_time:Float;
	private var _p_target:Int;
	private var _current_channel:Int;
	private var _current_time:Float;
	private var _previous_time:Float;
	
	private function _tick():Void {
		if(!_paused){
			_current_time = Date.now().getTime();
			_p_time = _current_time - _previous_time;
			for (i in 0..._processes.length){
				_processes[i]();
			}
			for (i in 0..._channels.length){
				_channels[i].tick(_p_time);
			}
			for (i in 0..._c_channels.length){
				_c_channels[i].tick(_p_time);
			}
			_previous_time = _current_time;
		}
	}
	
	public function new() {
		_processes = [];
		_channels = [];
		_c_channels = [];
		_interval = -1;
		_length = 0;
		_p_time = 0;
		_current_channel = 0;
		_current_time = 0;
		_paused = true;
		_previous_time = Date.now().getTime();
		setCPS(60);
	}
	
	/**
	 * Change calls per second, min of 1 and max of 240.
	 * @param	target
	 */
	public function setCPS(target:Int):Void {
		if(target < 1){
			target = 1;
		}else if(target > 240){
			target = 240;
		}
		_p_target = target;
		var target:Float = 1000 / _p_target;
		var diff:Float = target / _p_target;
		var count:Int = 0;
		var channel:FrameChannelProxy = null;
		while (count < 60){
			if(_channels[count] == null){
				channel = new FrameChannelProxy(this);
				_channels[count] = channel;
			}else{
				channel = _channels[count];
			}
			channel.update(target, diff * count);
			++count;
		}
	}
	
	/**
	 * Return one of 60 pre created channels for better runtime execution.
	 * @return
	 */
	public function getChannel():FrameChannel {
		if(_current_channel >= _channels.length){
			_current_channel = 0;
		}
		return _channels[_current_channel++].channel;
	}
	
	/**
	 * Return if Timer is running
	 * @return
	 */
	public function isActive():Bool {
		return !_paused;
	}
	
	/**
	 * Current Cals per second
	 * @return
	 */
	public function getCPS():Int {
		return _p_target;
	}
	
	/**
	 * Add a listener to active processes
	 * @param	handler
	 */
	public function add(handler:Dynamic):Void {
		if(!_processes.contains(handler)){
			_processes.push(handler);
		}
	}
	
	/**
	 * Remove listener from processes
	 * @param	handler
	 */
	public function remove(handler:Dynamic):Void {
		_processes.remove(handler);
	}
	
	/**
	 * Pause all processes
	 */
	public function pause():Void {
		if(_paused == false && _interval != -1){
			Syntax.code('clearInterval({0})', _interval);
			_interval = -1;
			_paused = true;
		}
	}
	
	/**
	 * Resume processes
	 */
	public function resume():Void {
		if (_paused == true && _interval == -1){
			_interval = Syntax.code('setInterval({0},1)', Syntax.code("{0}.bind({1})", _tick, this));
			_paused = false;
		}
	}
	
	/**
	 * Create a custom channel
	 * @param	time
	 * @return
	 */
	public function channel(time:Float):FrameChannel {
		var c:FrameChannelProxy = null;
		for(i in 0..._c_channels.length){
			c = _c_channels[i];
			if(c.time == time){
				return c.channel;
			}
		}
		c = new FrameChannelProxy(this);
		c.update(time, 0);
		_c_channels.push(c);
		return c.channel;
	}
	
	public function delayed(callback:Dynamic, delay:Float, repeat:Int = 0, ...rest:Dynamic):DelayedCall {
		return new DelayedCall(this, callback, delay, repeat, rest);
	}
	
}

private class FrameChannelProxy {
	
	public var target:Float;
	public var time:Float;
	public var channel:FrameChannel;
	public var processes:Array<Dynamic>;
	
	public function new(timer:Timer) {
		processes = [];
		channel = new FrameChannel(timer, processes);
	}
	
	public function update(target:Float, time:Float):Void {
		if (this.time != null && this.time != 0){
			this.time = this.time / this.target * time;
		}else{
			this.time = time;
		}
		this.target = target;
	}
	
	public function tick(time:Float):Void {
		this.time += time;
		channel.active = this.time >= target;
		if(channel.active){
			for (i in 0...processes.length){
				processes[i]();
			}
			this.time -= target;
		}
	}
	
}