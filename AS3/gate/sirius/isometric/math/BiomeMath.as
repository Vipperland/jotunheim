package gate.sirius.isometric.math {
	import gate.sirius.isometric.math.BiomePoint;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeMath {
		
		public static function cloneToFlexPoint(point:BiomePoint):BiomeFlexPoint {
			return new BiomeFlexPoint(point.x, point.y, point.z);
		}
		
		
		public static function costOfPointToPoint(from:BiomePoint, target:BiomePoint):int {
			var distX:int = target.x - from.x;
			var distY:int = target.y - from.y;
			var distZ:int = target.z - from.z;
			if (distX < 0)
				distX = -distX;
			if (distY < 0)
				distY = -distY;
			if (distZ < 0)
				distZ = -distZ;
			return (distX + distY + distZ);
		}
		
		
		public static function costOfPointToLocation(from:BiomePoint, x:int, y:int, z:int):int {
			var distX:int = x - from.x;
			var distY:int = y - from.y;
			var distZ:int = z - from.z;
			if (distX < 0)
				distX = -distX;
			if (distY < 0)
				distY = -distY;
			if (distZ < 0)
				distZ = -distZ;
			return (distX + distY + distZ);
		}
		
		
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
		
		
		public function iterateBounds(bounds:BiomeBounds, handler:Function, x:int = 0, y:int = 0, z:int = 0):void {
			var rx:int = x + bounds.width;
			var ry:int = y + bounds.height;
			var rz:int = z + bounds.depth;
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
	
	}

}