package gate.sirius.timer {
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ActiveController implements IActiveController {
		
		private var _fps:uint;
		
		private var _timer:Timer;
		
		private var _timeFactor:Number;
		
		private var _pools:Vector.<ActiveObjectPool>;
		
		private var _poolBySize:Dictionary;
		
		private var _objref:Dictionary;
		
		private var _delayedref:Dictionary;
		
		public function ActiveController(fps:uint = 60) {
			
			_timer = new Timer(1000, 0);
			_timer.addEventListener(TimerEvent.TIMER, _onTimerTick, false, 0, true);
			_objref = new Dictionary(true);
			_delayedref = new Dictionary(false);
			_pools = new Vector.<ActiveObjectPool>();
			_poolBySize = new Dictionary(true);
			_timeFactor = 1;
			
			setFPS(fps);
		
		}
		
		public function setFPS(fps:uint):void {
			
			var pool:ActiveObjectPool;
			var index:int = 1;
			
			_fps = fps;
			_timer.delay = 1000 / fps;
			
			// register existing indexes
			var current:Vector.<uint> = new Vector.<uint>();
			for each (pool in _pools) {
				current[current.length] = pool.size;
			}
			
			// create missing indexes
			while (index < fps) {
				var size:uint = (fps / index) >> 0;
				if (size > 0 && current.indexOf(size) == -1) {
					pool = new ActiveObjectPool(size);
					_pools[_pools.length] = pool;
					_poolBySize[size] = pool;
					current[current.length] = size;
				}
				++index;
			}
			
			//remove unused pools
			for each (pool in _pools) {
				index = current.indexOf(size);
				if (index == -1) {
					delete _poolBySize[pool.size];
					_pools.splice(index, 1)[0].dispose();
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
			var target:int = _fps / fps;
			_objref[object] = (_poolBySize[target] as ActiveObjectPool).add(object);
			object.onActivate(this);
			return this;
		}
		
		public function unregister(object:IActiveObject, silent:Boolean = false):IActiveController {
			(_objref[object] as ActiveObjectData).discard();
			if (!silent) {
				object.onDeactivate(this);
			}
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
		
		public function delayedCall(handler:Function, milisseconds:int, repeats:int = 0, ... paramaters:Array):void {
			cancelDelayedCall(handler);
			_delayedref[handler] = DelayedCallToken.recycle(handler, milisseconds, repeats, paramaters);
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