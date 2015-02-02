package gate.sirius.isometric.signal {
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.math.BiomePoint;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeColliderSignal extends BiomeEntrySignal {
		
		protected var _origin:BiomePoint;
		
		protected var _costOf:int;
		
		private function _contructor(origin:BiomePoint, tile:BiomeEntry, costOf:int = 0):void {
			_costOf = costOf;
			_origin = origin;
			_tile = tile;
		}
		
		public function BiomeColliderSignal(constructor:Function = null) {
			super(_resolveHandler(constructor, _contructor));
		}
		
		public function get origin():BiomePoint {
			return _origin;
		}
		
		public function get costOf():int {
			return _costOf;
		}
		
		override public function dispose(recyclable:Boolean):void {
			_origin = null;
			super.dispose(recyclable);
		}
	
	}

}