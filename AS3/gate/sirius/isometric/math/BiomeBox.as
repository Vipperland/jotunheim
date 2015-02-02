package gate.sirius.isometric.math {
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeBox {
		
		protected var _width:int;
		
		protected var _height:int;
		
		protected var _depth:int;
		
		
		public function BiomeBox(width:int, height:int, depth:int) {
			transform(width, height, depth);
		}
		
		
		public function get width():int {
			return _width;
		}
		
		
		public function set width(value:int):void {
			_width = value || 1;
		}
		
		
		public function get height():int {
			return _height;
		}
		
		
		public function set height(value:int):void {
			_height = value || 1;
		}
		
		
		public function get depth():int {
			return _depth;
		}
		
		
		public function set depth(value:int):void {
			_depth = value || 1;
		}
		
		
		public function validate(location:BiomePoint, bounds:BiomeBox):Boolean {
			
			var tx:int = location.x;
			var ty:int = location.y;
			var tz:int = location.z;
			
			if (tx < 0 || ty < 0 || tz < 0)
				return false;
			
			tx += bounds._width;
			ty += bounds._height;
			tz += bounds._depth;
			
			if (tx > _width || ty > _height || tz > _height)
				return false;
			
			return true;
		}
		
		
		public function transform(width:int, height:int, depth:int):void {
			_depth = depth || 1;
			_height = height || 1;
			_width = width || 1;
		}
		
		
		public function clone():BiomeBox {
			return new BiomeBox(_width, _height, _depth);
		}
	
	}

}