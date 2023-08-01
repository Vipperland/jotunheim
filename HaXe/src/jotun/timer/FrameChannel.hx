package jotun.timer;

/**
 * ...
 * @author Rafael Moreira
 */
class FrameChannel {
	
	private var _timer:Timer;
	
	private var _processes:Array<Dynamic>;
	
	public var active:Bool;
	
	public function new(timer:Timer, processeses:Array<Dynamic>) {
		_timer = timer;
		_processes = processeses;
	}
	
	public function getTimer():Timer {
		return _timer;
	}
	
	public function add(handler:Dynamic):Void {
		if(!_processes.contains(handler)){
			_processes.push(handler);
		}
	}
	
	public function remove(handler:Dynamic):Void {
		_processes.remove(handler);
	}
	
}