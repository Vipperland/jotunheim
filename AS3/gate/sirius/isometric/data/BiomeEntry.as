package gate.sirius.isometric.data {
	
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.signal.BiomeEntrySignal;
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeEntry {
		
		/** @private */
		private var _neighbors:BiomeNeighbor;
		
		/** @private */
		private var _biome:Biome;
		
		/** @private */
		private var _location:BiomePoint;
		
		/** @private */
		private var _occupation:Vector.<BiomeMatter>;
		
		/** @private */
		private var _depth:Number;
		
		/**
		 * Data registrada a entrada
		 */
		public var data:Object;
		
		
		/**
		 * Cria a instancia de uma nova entrada em um Bioma
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	biome
		 */
		public function BiomeEntry(x:int, y:int, z:int, biome:Biome) {
			_biome = biome;
			_location = BiomePoint.create(x, y, z);
			_occupation = new Vector.<BiomeMatter>();
			_neighbors = new BiomeNeighbor(this, _biome);
		}
		
		
		public function create():void {
			_biome.signals.TILE_CREATE.send(BiomeEntrySignal, true, this);
		}
		
		
		/**
		 * Pontos de fuga da entrada
		 */
		public function get neighbors():BiomeNeighbor {
			return _neighbors;
		}
		
		
		/**
		 * Localização do Bioma
		 */
		public function get location():BiomePoint {
			return _location;
		}
		
		
		/**
		 * Matérias que ocupam a entrada
		 */
		public function get occupation():Vector.<BiomeMatter> {
			return _occupation;
		}
		
		
		/**
		 * Filtra a ocupação por um tipo específico ou seleciona toda matéria
		 * @param	callback
		 * @param	type
		 */
		public function occupationFilter(ObjectClass:Class = null, callback:Function = null):Vector.<BiomeMatter> {
			var r:Vector.<BiomeMatter> = new Vector.<BiomeMatter>();
			var useCallback:Boolean = callback is Function;
			for each (var matter:BiomeMatter in _occupation) {
				if (!ObjectClass || matter is ObjectClass) {
					r[r.length] = matter;
					if (useCallback) {
						callback(matter as ObjectClass);
					}
				}
			}
			return r;
		}
		
		
		/**
		 * Verifica se um tipo de matéria específico ocupa a posição
		 * @param	type
		 * @return
		 */
		public function isOccupiedBy(ObjectClass:Class):BiomeMatter {
			for each (var matter:BiomeMatter in _occupation) {
				if (matter is ObjectClass) {
					return matter;
				}
			}
			return null;
		}
		
		
		/**
		 * Bioma de alocação da entrada
		 */
		public function get biome():Biome {
			return _biome;
		}
		
		
		public function toString():String {
			return "[BiomeEntry data=" + data + " neighbors=" + neighbors + " location=" + location + " occupation=" + occupation.length + " id=" + id + "]";
		}
		
		
		/**
		 * Identificador unico de entrada
		 * @return
		 */
		public function get id():String {
			return "tile_" + _location.x + "_" + _location.y + "_" + _location.z;
		}
		
		
		/**
		 * Visibilidade do tile na Viewport
		 * @return
		 */
		public function isVisible():Boolean {
			return _biome.viewport.isTileVisible(this);
		}
	
	}

}