package gate.sirius.isometric.matter {
	import gate.sirius.isometric.math.BiomeAllocation;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	import gate.sirius.signals.SignalDispatcher;
	import gate.sirius.timer.IActiveController;
	import gate.sirius.timer.IActiveObject;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class OrganicBiomeMatter extends BiomeMatter implements IActiveObject {
		
		/** @private */
		private var _fps:uint;
		
		/** @private */
		protected var _ticker:IActiveController;
		
		/** @private */
		protected var _toUpdate:Boolean;
		
		/** @private */
		protected var _idle:Boolean;
		
		
		public function OrganicBiomeMatter(name:String, allocation:BiomeAllocation = null, location:BiomeFlexPoint = null, fps:uint = 10, content:* = null) {
			super(name, allocation, location, content);
			this._fps = fps;
		
		}
		
		
		/**
		 * Force matter update
		 */
		public function forceUpdate():void {
			super.post();
		}
		
		
		override public function post():void {
			if (_parent) {
				_tile = null;
				_toUpdate = true;
			}
		}
		
		
		/**
		 * Skips the Ticker phase
		 */
		public function get idle():Boolean {
			return _idle;
		}
		
		
		public function set idle(value:Boolean):void {
			_idle = value;
		}
		
		
		/**
		 * Target FPS for Ticker
		 */
		public function get fps():uint {
			return _fps;
		}
		
		
		public function set fps(value:uint):void {
			if (_ticker) {
				_ticker.unregister(this, true);
				_ticker.register(this, value);
			}
			_fps = value;
		}
		
		
		/* INTERFACE gate.sirius.timer.IActiveObject */
		
		/**
		 *
		 * @param	time
		 */
		public function tick(time:Number):void {
			if (!_idle) {
				if (_toUpdate && _parent) {
					_toUpdate = false;
					_parent.postMatter(this);
				}
			}
		}
		
		
		/**
		 *
		 */
		public function onActivate(ticker:IActiveController):void {
			_ticker = ticker;
		}
		
		
		/**
		 *
		 */
		public function onDeactivate(ticker:IActiveController):void {
			_ticker = null;
		}
	
	}

}