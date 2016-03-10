package gate.sirius.isometric.math {
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeMath {
		
		/**
		 *
		 * @param	point
		 * @return
		 */
		public static function cloneToFlexPoint(point:BiomePoint):BiomeFlexPoint {
			return new BiomeFlexPoint(point.x, point.y, point.z);
		}
		
		
		/**
		 *
		 * @param	from
		 * @param	target
		 * @return
		 */
		public static function costOfPointToPoint(from:BiomePoint, target:BiomePoint):int {
			return costOfLocationToLocation(from.x, from.y, from.z, target.x, target.y, target.z);
		}
		
		
		/**
		 *
		 * @param	from
		 * @param	x
		 * @param	y
		 * @param	z
		 * @return
		 */
		public static function costOfPointToLocation(from:BiomePoint, x:int, y:int, z:int):int {
			return costOfLocationToLocation(from.x, from.y, from.z, x, y, z);
		}
		
		
		/**
		 *
		 * @param	x1
		 * @param	y1
		 * @param	z1
		 * @param	x2
		 * @param	y2
		 * @param	z2
		 * @return
		 */
		public static function costOfLocationToLocation(x1:int, y1:int, z1:int, x2:int, y2:int, z2:int):int {
			var distX:int = x2 - x1;
			var distY:int = y2 - y1;
			var distZ:int = z2 - z1;
			if (distX < 0)
				distX = -distX;
			if (distY < 0)
				distY = -distY;
			if (distZ < 0)
				distZ = -distZ;
			return (distX + distY + distZ);
		}
		
		
		/**
		 *
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	width
		 * @param	height
		 * @param	depth
		 * @param	handler
		 */
		public static function iterateArea(x:int, y:int, z:int, width:int, height:int, depth:int, handler:Function):void {
			var rx:int = x + width;
			var ry:int = y + height;
			var rz:int = z + depth;
			var cx:int = x;
			var cy:int = y;
			var cz:int = z;
			while (cz < rz) {
				while (cy < ry) {
					while (cx < rx) {
						handler(cx, cy, cz);
						++cx;
					}
					cx = x;
					++cy;
				}
				cy = y;
				++cz;
			}
		}
		
		
		/**
		 *
		 * @param	bounds
		 * @param	handler
		 * @param	x
		 * @param	y
		 * @param	z
		 */
		public static function iterateBounds(bounds:BiomeBounds, handler:Function, x:int = 0, y:int = 0, z:int = 0):void {
			iterateArea(x, y, z, bounds.width, bounds.height, bounds.depth, handler);
		}
		
		
		/**
		 *
		 * @param	bounds
		 * @param	handler
		 * @param	location
		 */
		public static function iterateLocaton(bounds:BiomeBounds, handler:Function, location:BiomePoint):void {
			iterateArea(location._x, location._y, location._z, bounds.width, bounds.height, bounds.depth, handler);
		}
		
		
		/**
		 *
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	width
		 * @param	height
		 * @param	depth
		 * @return
		 */
		public static function expandLocation(x:int, y:int, z:int, width:uint, height:uint, depth:uint):BiomePoint {
			return new BiomePoint(x * width, y * height, z * depth);
		}
		
		
		/**
		 *
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	width
		 * @param	height
		 * @param	depth
		 * @return
		 */
		public static function implodeLocation(x:int, y:int, z:int, width:uint, height:uint, depth:uint):BiomePoint {
			if (x < 0)
				x -= width;
			if (y < 0)
				y -= height;
			return BiomePoint.create(x / width, y / height, z / depth);
		}
	
	}

}