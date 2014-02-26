package gate.sirius.timer {
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ActiveController implements IActiveController {
		
		//static private var _gate:IActiveController;
		//
		//static public function get GATE():IActiveController {
		//return _gate ||= new ActiveController();
		//}
		
		static public const GATE:IActiveController = new ActiveController();
		
		private var _fps:uint;
		
		private var _timer:Timer;
		
		private var _timeFactor:Number;
		
		private var _pools:Vector.<ActiveObjectPool>;
		
		private var _objref:Dictionary;
		
		private var _delayedref:Dictionary;
		
		public function ActiveController() {
			
			_timer = new Timer(1000, 0);
			_timer.addEventListener(TimerEvent.TIMER, _onTimerTick, false, 0, true);
			_objref = new Dictionary(true);
			_delayedref = new Dictionary(false);
			_pools = new Vector.<ActiveObjectPool>();
			_timeFactor = 1;
			
			setFPS(60);
		
		}
		
		public function setFPS(fps:int):void {
			_fps = fps;
			_timer.delay = 1000 / fps;
			
			if (_pools.length > fps) {
				_pools.splice(fps, _pools.length - fps);
			} else {
				var i:int = _pools.length;
				while (i < fps) {
					if (i in _pools)
						_pools[i] = new ActiveObjectPool(i + 1);
					++i;
				}
			}
		}
		
		public function start():IActiveController {
			_timer.start();
			return this;
		}
		
		public function stop():IActiveController {
			_timer.stop();
			return this;
		}
		
		private function _onTimerTick(e:TimerEvent):void {
			_tickAllPools();
		}
		
		private function _tickAllPools():void {
			for each (var pool:ActiveObjectPool in _pools) {
				pool.tick(_timeFactor);
			}
		}
		
		public function register(object:IActiveObject, fps:uint):IActiveController {
			if (fps > _fps) {
				fps = _fps;
			}
			var target:int = _fps - fps;
			_objref[object] = _pools[target].add(object);
			return this;
		}
		
		public function unregister(object:IActiveObject):IActiveController {
			(_objref[object] as ActiveObjectData).discard();
			delete _objref[object];
			return this;
		}
		
		public function get fps():uint {
			return _fps;
		}
		
		public function get timeFactor():Number {
			return _timeFactor;
		}
		
		public function set timeFactor(value:Number):void {
			_timeFactor = value;
		}
		
		public function delayedCall(handler:Function, time:int, repeats:int = 0, ... paramaters:Array):void {
			cancelDelayedCall(handler);
			_delayedref[handler] = DelayedCallToken.recycle(handler, time, repeats, paramaters);
		}
		
		public function cancelDelayedCall(handler:Function):void {
			if (_delayedref[handler]) {
				_delayedref[handler].cancel();
				delete _delayedref[handler];
			}
		}
		
		public function cancellAllCalls():void {
			for (var call:*in _delayedref) {
				cancelDelayedCall(call);
			}
		}
	
	}

}