package gate.sirius.isometric.signal {
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.data.BiomeEntry;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeNeighborSignal extends BiomeEntrySignal {
		
		public static const FOUND:String = "found";
		
		public static const CASCADE:String = "cascade";
		
		public static const FLOW:String = "cascade";
		
		protected var _neighbor:BiomeEntry;
		
		public function BiomeNeighborSignal(name:String, tile:BiomeEntry, neighbor:BiomeEntry) {
			super(name, tile);
			_neighbor = neighbor;
		
		}
		
		public function get neighbor():BiomeEntry {
			return _neighbor;
		}
	
	}

}