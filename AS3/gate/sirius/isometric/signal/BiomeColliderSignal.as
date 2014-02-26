package gate.sirius.isometric.signal {
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.math.BiomePoint;
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeColliderSignal extends BiomeFindSignal {
		
		/// Objetos na intersecção do raio de colisão
		public static const PATH:String = "path";
		
		/// Objeto relacionado a colisão
		public static const COLLISION:String = "collision";
		
		/// Nenhuma entrada de colisão
		public static const NONE:String = "none";
		
		
		/**
		 * Cria uma instancia do sinal de colisão
		 * @param	name
		 * @param	origin
		 * @param	tile
		 * @param	costOf
		 */
		public function BiomeColliderSignal(name:String, origin:BiomePoint, tile:BiomeEntry, costOf:int = 0) {
			super(name, origin, tile, costOf);
		}
	
	}

}