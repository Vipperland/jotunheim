package gate.sirius.isometric.signal {
	
	import gate.sirius.isometric.data.BiomeEntry;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeEntrySignal extends BiomeSignal {
		
		protected var _tile:BiomeEntry;
		
		private function _constructor(tile:BiomeEntry):void {
			_tile = tile;
		}
		
		public function BiomeEntrySignal(constructor:Function = null) {
			super(_resolveHandler(constructor, _constructor));
		
		}
		
		public function get tile():BiomeEntry {
			return _tile;
		}
		
		override public function dispose(recyclable:Boolean):void {
			_tile = null;
			super.dispose(recyclable);
		}
	
	}

}