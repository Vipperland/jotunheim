package gate.sirius.isometric.signal {
	import gate.sirius.isometric.Biome;
	import gate.sirius.signals.Signal;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeSignal extends Signal {
		
		private var _biome:Biome;
		
		private function _constructor():void {
		
		}
		
		public function BiomeSignal(contructor:Function = null) {
			super(_resolveHandler(contructor, _constructor));
		}
		
		public function get biome():Biome {
			return _biome ||= dispatcher.author as Biome;
		}
		
		override public function dispose(recyclable:Boolean):void {
			_biome = null;
			super.dispose(recyclable);
		}
	
	}
}