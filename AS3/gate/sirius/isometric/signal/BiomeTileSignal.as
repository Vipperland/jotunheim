package gate.sirius.isometric.signal {
	
	import gate.sirius.isometric.data.BiomeEntry;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeTileSignal extends BiomeSignal {
		
		public static const CREATED:String = "created";
		
		public static const SHOW:String = "show";
		
		public static const HIDE:String = "hide";
		
		protected var _tile:BiomeEntry;
		
		public function BiomeTileSignal(name:String, tile:BiomeEntry) {
			super(name);
			_tile = tile;
		}
		
		public function get tile():BiomeEntry {
			return _tile;
		}
	
	}

}