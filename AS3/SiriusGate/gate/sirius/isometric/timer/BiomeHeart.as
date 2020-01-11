package gate.sirius.isometric.timer {
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Rim Project
	 */
	public class BiomeHeart {
		
		private static var _ME:BiomeHeart;
		
		private var _objects:Dictionary;
		
		private var _timer:Timer;
		
		static public function get ME():BiomeHeart {
			if (_ME == null){
				_ME = new BiomeHeart();
			}
			return _ME;
		}
		
		private function _init():void {
			_objects = new Dictionary(true);
			_timer = new Timer(16.666, 0);
			_timer.addEventListener(TimerEvent.TIMER, _onBeat);
			start();
		}
		
		private function _onBeat(e:Event):void {
			for each(var obj:ObjData in _objects){
				obj.tick();
			}
		}
		
		public function BiomeHeart() {
			_init();
		}
		
		public function start():void {
			_timer.start();
		}
		
		public function stop():void {
			_timer.stop();
		}
		
		public function connect(object:IHeartbeat):void {
			if (_objects[object] == null){
				_objects[object] = new ObjData(object);
			}
		}
		
		public function disconnect(object:IHeartbeat):void {
			if (_objects[object] != null){
				delete _objects[object];
			}
		}
		
	}

}

import gate.sirius.isometric.timer.IHeartbeat;

class ObjData {
	
	public var ups:uint;
	public var count:int;
	public var object:IHeartbeat;
	
	public function ObjData(object:IHeartbeat){
		this.object = object;
		this.ups = (60/object.ups) >> 1;
		this.count = 0;
	}
	public function tick():void {
		if (++count > this.ups){
			object.pulse(count);
			count = 0;
		}
	}
}
