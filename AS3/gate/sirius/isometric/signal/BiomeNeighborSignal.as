package gate.sirius.isometric.signal {
	import gate.sirius.isometric.data.BiomeEntry;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeNeighborSignal extends BiomeEntrySignal {
		
		protected var _neighbor:BiomeEntry;
		
		private function _constructor(tile:BiomeEntry, neighbor:BiomeEntry):void {
			_tile = tile;
			_neighbor = neighbor;
		}
		
		public function BiomeNeighborSignal(constructor:Function = null) {
			super(_resolveHandler(constructor, _constructor));
		}
		
		public function get neighbor():BiomeEntry {
			return _neighbor;
		}
		
		override public function dispose(recyclable:Boolean):void {
			_neighbor = null;
			super.dispose(recyclable);
		}
	
	}

}