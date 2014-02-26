package gate.sirius.isometric.math {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeBox {
		
		protected var _width:int;
		
		protected var _height:int;
		
		protected var _depth:int;
		
		
		public function BiomeBox(width:int, height:int, depth:int = 1) {
			_depth = depth;
			_height = height;
			_width = width;
		
		}
		
		
		public function get width():int {
			return _width;
		}
		
		
		public function set width(value:int):void {
			_width = value;
		}
		
		
		public function get height():int {
			return _height;
		}
		
		
		public function set height(value:int):void {
			_height = value;
		}
		
		
		public function get depth():int {
			return _depth;
		}
		
		
		public function set depth(value:int):void {
			_depth = value;
		}
	
	}

}