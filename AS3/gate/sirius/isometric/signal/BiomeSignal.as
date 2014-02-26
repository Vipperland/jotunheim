package gate.sirius.isometric.signal {
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.signals.Signal;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeSignal extends Signal {
		
		private var _biome:Biome;
		
		public function BiomeSignal(name:String) {
			super(name);
		}
		
		public function get biome():Biome {
			return _biome ||= from.author as Biome;
		}
	
	}
}