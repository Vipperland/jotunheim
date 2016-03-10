package gate.sirius.isometric.math {
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomePoint {
		
		public static const CACHED:Array = new Array();
		
		public static const ZERO:BiomePoint = BiomePoint.create(0, 0, 0);
		
		public static function create(x:int, y:int, z:int):BiomePoint {
			return ((CACHED[z] ||= [])[y] ||= [])[x] ||= new BiomePoint(x, y, z);
		}
		
		internal var _x:int;
		
		internal var _y:int;
		
		internal var _z:int;
		
		internal var _left:BiomePoint;
		
		internal var _right:BiomePoint;
		
		internal var _top:BiomePoint;
		
		internal var _bottom:BiomePoint;
		
		internal var _front:BiomePoint;
		
		internal var _back:BiomePoint;
		
		internal var _id:String;
		
		public function BiomePoint(x:int, y:int, z:int) {
			_z = z;
			_y = y;
			_x = x;
		}
		
		/**
		 * Orthographic Projection X
		 */
		public function get x():int {
			return _x;
		}
		
		/**
		 * Orthographic Projection Y
		 */
		public function get y():int {
			return _y;
		}
		
		/**
		 * Orthographic Projection Z
		 */
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
			return _left ||= BiomePoint.create(getLeft(), _y, _z);
		}
		
		public function getRightPoint():BiomePoint {
			return _right ||= BiomePoint.create(getRight(), _y, _z);
		}
		
		public function getTopPoint():BiomePoint {
			return _top ||= BiomePoint.create(_x, getTop(), _z);
		}
		
		public function getBottomPoint():BiomePoint {
			return _bottom ||= BiomePoint.create(_x, getBottom(), _z);
		}
		
		public function getFrontPoint():BiomePoint {
			return _front ||= BiomePoint.create(_x, _y, getFront());
		}
		
		public function getBackPoint():BiomePoint {
			return _back ||= BiomePoint.create(_x, _y, getBack());
		}
		
		/**
		 * Get a new point from here
		 * @param	target
		 * @return
		 */
		public function getDirection(target:BiomePoint):BiomePoint {
			return BiomePoint.create(_x + target._x, _y + target._y, _z + target._z);
		}
		
		/**
		 * Return the distance of each axis from this to another point
		 * @param	from
		 * @return
		 */
		public function getDistance(from:BiomePoint):BiomePoint {
			return BiomePoint.create(from.x - _x, from.y - _y, from.z - _z);
		}
		
		public function getMagnitude():Number {
			return Math.sqrt(_x * _x + _y * _y + _z * _z);
		}
		
		/**
		 * Isometric axys X
		 */
		public function get ax():int {
			return _x - _y;
		}
		
		/**
		 * Isometric axys Y
		 */
		public function get ay():int {
			return _x + _y - _z;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function offset(point:BiomePoint):BiomePoint {
			return BiomePoint.create(_x + point.x, _y + point.y, _z + point.z);
		}
		
		public function isEqual(location:BiomePoint):Boolean {
			return location == this || location.x == _x && location.y == _y && location.z == _z;
		}
		
		public function toString():String {
			return "[BiomePoint (x:" + _x + ", y:" + _y + ", z:" + _z + ")]";
		}
		
		public function limit(x1:int, y1:int, z1:int, x2:int, y2:int, z2:int):BiomePoint {
			return BiomePoint.create(x < x1 ? x1 : x > x2 ? x2 : x, y < y1 ? y1 : y > y2 ? y2 : y, z < z1 ? z1 : z > z2 ? z2 : z);
		}
	
	}

}