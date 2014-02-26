package gate.sirius.isometric.math {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomePoint {
		
		public static const ZERO:BiomePoint = new BiomePoint(0, 0, 0);
		
		internal var _x:int;
		
		internal var _y:int;
		
		internal var _z:int;
		
		internal var _left:BiomePoint;
		
		internal var _right:BiomePoint;
		
		internal var _top:BiomePoint;
		
		internal var _bottom:BiomePoint;
		
		internal var _front:BiomePoint;
		
		internal var _back:BiomePoint;
		
		
		public function BiomePoint(x:int, y:int, z:int) {
			_z = z;
			_y = y;
			_x = x;
		}
		
		
		public function get x():int {
			return _x;
		}
		
		
		public function get y():int {
			return _y;
		}
		
		
		public function get z():int {
			return _z;
		}
		
		
		public function getLeft():int {
			return _x - 1;
		}
		
		
		public function getRight():int {
			return _x + 1;
		}
		
		
		public function getTop():int {
			return _y - 1;
		}
		
		
		public function getBottom():int {
			return _y + 1;
		}
		
		
		public function getFront():int {
			return _z - 1;
		}
		
		
		public function getBack():int {
			return _z + 1;
		}
		
		
		public function getLeftPoint():BiomePoint {
			return _left ||= new BiomePoint(getLeft(), _y, _z);
		}
		
		
		public function getRightPoint():BiomePoint {
			return _right ||= new BiomePoint(getRight(), _y, _z);
		}
		
		
		public function getTopPoint():BiomePoint {
			return _top ||= new BiomePoint(_x, getTop(), _z);
		}
		
		
		public function getBottomPoint():BiomePoint {
			return _bottom ||= new BiomePoint(_x, getBottom(), _z);
		}
		
		
		public function getFrontPoint():BiomePoint {
			return _front ||= new BiomePoint(_x, _y, getFront());
		}
		
		
		public function getBackPoint():BiomePoint {
			return _back ||= new BiomePoint(_x, _y, getBack());
		}
		
		
		/**
		 * Get a new point from here
		 * @param	x
		 * @param	y
		 * @param	z
		 * @return
		 */
		public function getDirection(x:int, y:int, z:int):BiomePoint {
			return new BiomePoint(_x + x, _y + y, _z + z);
		}
		
		
		/**
		 * Return the distance of each axis from this to another point
		 * @param	from
		 * @return
		 */
		public function getDistance(from:BiomePoint):BiomePoint {
			return new BiomePoint(from.x - _x, from.y - _y, from.z - _z);
		}
		
		
		public function getMagnitude():Number {
			return Math.sqrt(_x * _x + _y * _y + _z * _z);
		}
		
		
		public function getArea():int {
			return (x > 0 ? x : 1) * (y > 0 ? y : 1) * (z > 0 ? z : 1);
		}
		
		
		public function toString():String {
			return "[BiomePoint x=" + _x + " y=" + _y + " z=" + _z + "]";
		}
		
		
		public function get ax():int {
			return _x + _y;
		}
		
		
		public function get ay():int {
			return _x - _y;
		}
		
		
		public function get az():int {
			return _z;
		}
		
		
		public function math(location:BiomePoint):Boolean {
			return location.x == _x && location.y == _y && location.z == _z;
		}
	
	}

}