package gate.sirius.isometric.signal {
	import gate.sirius.isometric.matter.BiomeMatter;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeMatterSignal extends BiomeSignal {
		
		public static const ADDED:String = "added";
		
		public static const REMOVED:String = "removed";
		
		public static const UPDATED:String = "updated";
		
		protected var _matter:BiomeMatter;
		
		
		public function BiomeMatterSignal(name:String, matter:BiomeMatter) {
			_matter = matter;
			super(name);
		}
		
		
		public function get matter():BiomeMatter {
			return _matter;
		}
	
	}

}