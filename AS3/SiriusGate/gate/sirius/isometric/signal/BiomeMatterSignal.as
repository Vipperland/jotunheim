package gate.sirius.isometric.signal {
	import gate.sirius.isometric.matter.BiomeMatter;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeMatterSignal extends BiomeSignal {
		
		protected var _matter:BiomeMatter;
		
		private function _contructor(matter:BiomeMatter):void {
			_matter = matter;
		}
		
		public function BiomeMatterSignal() {
			super(_contructor);
		}
		
		
		public function get matter():BiomeMatter {
			return _matter;
		}
	
	}

}