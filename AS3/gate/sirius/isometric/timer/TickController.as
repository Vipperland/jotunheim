package gate.sirius.isometric.timer {
	
	import flash.events.TimerEvent;
	
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class TickController {
		
		private var _FPS:int;
		
		private var _timer:Timer;
		
		private var _queued:Vector.<Vector.<IActiveObject>>;
		
		private var _cursor:int = 0;
		
		private var _timeScale:Number = 1;
		
		private var _lastIndex:int = 0;
		
		private var _collection:Dictionary;
		
		
		public function TickController(FPS:int = 30) {
			_FPS = FPS;
			_queued = new Vector.<Vector.<IActiveObject>>();
			_collection = new Dictionary(true);
			while (FPS > 0) {
				_queued[_FPS - FPS] = new Vector.<IActiveObject>();
				--FPS;
			}
			_timer = new Timer(1000 / _FPS, 0);
			_timer.addEventListener(TimerEvent.TIMER, _onTimerTick, false, 0, true);
			unpause();
		}
		
		
		private function _onTimerTick(e:TimerEvent):void {
			var index:int = 0;
			var target:Vector.<IActiveObject> = _queued[_cursor];
			var total:int = target.length;
			for (index = 0; index < total; ++index) {
				target[index].tick(_timeScale);
			}
			if (++_cursor == _FPS) {
				_cursor = 0;
			}
		}
		
		
		public function pause():void {
			_timer.stop();
		}
		
		
		public function unpause():void {
			_timer.start();
		}
		
		
		public function addObject(obj:IActiveObject, fps:int):void {
			if (_collection[obj]) {
				removeObject(obj);
			}
			if (fps <= 0) {
				fps = _FPS;
			}
			_collection[obj] = fps;
			var skip:int = _FPS / fps;
			var target:Vector.<IActiveObject>;
			while (fps > 0) {
				target = _queued[_lastIndex];
				target[target.length] = obj;
				_shiftIndex(skip);
				--fps;
			}
			_shiftIndex(1);
			obj.activated();
		}
		
		
		protected function _shiftIndex(ammount:int):void {
			_lastIndex += ammount;
			if (_lastIndex >= _FPS) {
				_lastIndex -= _FPS;
			}
		}
		
		
		public function removeObject(obj:IActiveObject):void {
			if (!_collection[obj]) {
				return;
			}
			var target:Vector.<IActiveObject>;
			var total:int = _queued.length;
			for (var index:int = 0; index < total; ++index) {
				target = _queued[index];
				var iof:int = target.indexOf(obj);
				if (iof !== -1) {
					target.splice(iof, 1);
					obj.inactivated();
				}
			}
		}
		
		
		public function get timeScale():Number {
			return _timeScale;
		}
		
		
		public function set timeScale(value:Number):void {
			_timeScale = value;
		}
		
		
		public function get FPS():int {
			return _FPS;
		}
		
		
		public function getObjectFPS(obj:IActiveObject):int {
			return _collection[obj] || 0;
		}
	
	}

}