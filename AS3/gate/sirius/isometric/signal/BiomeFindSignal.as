package gate.sirius.isometric.signal {
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.math.BiomePoint;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeFindSignal extends BiomeEntrySignal {
		
		public static const FIND:String = "find";
		
		protected var _found:BiomeEntry;
		
		protected var _origin:BiomePoint;
		
		protected var _costOf:int;
		
		public function BiomeFindSignal(name:String, origin:BiomePoint, tile:BiomeEntry, costOf:int = 0) {
			super(name, tile)
			_costOf = costOf;
			_origin = origin;
			_found = found;
		}
		
		public function get found():BiomeEntry {
			return _found;
		}
		
		public function get origin():BiomePoint {
			return _origin;
		}
		
		public function get costOf():int {
			return _costOf;
		}
	
	}

}