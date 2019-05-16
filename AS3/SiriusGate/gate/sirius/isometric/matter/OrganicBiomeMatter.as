package gate.sirius.isometric.matter {
	import gate.sirius.isometric.math.BiomeAllocation;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class OrganicBiomeMatter extends BiomeMatter implements IOrganicBiomeMatter {
		
		/** @private */
		private var _ups:uint;
		
		/** @private */
		protected var _toUpdate:Boolean;
		
		/** @private */
		protected var _idle:Boolean;
		
		
		public function OrganicBiomeMatter(name:String, allocation:BiomeAllocation = null, location:BiomeFlexPoint = null, ups:uint = 10, content:* = null) {
			super(name, allocation, location, content);
			this._ups = ups;
		
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
		public function get ups():uint {
			return _ups;
		}
		
		/**
		 *
		 * @param	time
		 */
		public function pulse(time:Number):void {
			if (!_idle) {
				_behaviours.onPulse();
				if (_toUpdate && _parent != null) {
					_toUpdate = false;
					_parent.postMatter(this);
				}
			}
		}
		
	}

}