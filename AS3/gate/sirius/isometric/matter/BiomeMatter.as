package gate.sirius.isometric.matter {
	
	import gate.sirius.isometric.Biome;
	import flash.display.DisplayObject;
	
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	
	import gate.sirius.isometric.recycler.IRecyclable;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeMatter implements IRecyclable {
		
		/** @private */
		public static var MATTER_COUNT:int = 0;
		
		/** @private */
		protected var _bounds:BiomeBounds;
		
		/** @private */
		protected var _name:String;
		
		/** @private */
		protected var _parent:Biome;
		
		/** @private */
		protected var _location:BiomeFlexPoint;
		
		/** @private */
		protected var _content:DisplayObject;
		
		
		/** @private */
		protected function _onParentAvailable():void {
		
		}
		
		
		/**
		 * Cria uma nova matter
		 * @param	name
		 * @param	bounds
		 * @param	location
		 */
		public function BiomeMatter(name:String, bounds:BiomeBounds = null, location:BiomeFlexPoint = null) {
			_bounds = bounds || new BiomeBounds();
			_location = location || new BiomeFlexPoint(0, 0, 0);
			_name = name || "Matter" + (++MATTER_COUNT);
		}
		
		
		/**
		 * Bioma responsável pela matéria
		 */
		public function get parent():Biome {
			return _parent;
		}
		
		
		public function set parent(value:Biome):void {
			if (_parent) {
				if (_parent !== value) {
					_parent.removeMatter(this);
				}
			}
			_parent = value;
			_onParentAvailable();
		}
		
		
		/**
		 * Nome da matéria
		 */
		public function get name():String {
			return _name;
		}
		
		
		/**
		 * Espaço de alocação da matéria no Bioma
		 */
		public function get bounds():BiomeBounds {
			return _bounds;
		}
		
		
		/**
		 * Localização da matter no Bioma
		 * Necessário executar post() para a atualização da matéria
		 */
		public function get location():BiomeFlexPoint {
			return _location;
		}
		 
		
		public function set location(value:BiomeFlexPoint):void {
			_location = value;
		}
		
		
		public function get content():DisplayObject {
			return _content;
		}
		
		
		/**
		 * Atualiza as informações de ocupação da matter em um Bioma
		 */
		public function post():void {
			if (_parent) {
				_parent.postMatter(this);
			}
		}
		
		
		/* INTERFACE alchemy.vipperland.isometric.recycler.IRecyclable */
		
		public function onDump():void {
		
		}
		
		
		public function onCollect():void {
		
		}
		
		
		public function syncLocation(width:Number = 1, height:Number = 1):void {
			if (_content) {
				_content.x = location.x * width;
				_content.y = location.y * height
			}
		}
	
	}

}