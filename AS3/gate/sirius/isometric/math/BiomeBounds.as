package gate.sirius.isometric.math {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeBounds {
		
		static public function BOX(width:int, height:int, depth:int):BiomeBounds {
			var bounds:BiomeBounds = new BiomeBounds();
			bounds.setArea(width, height, depth);
			return bounds;
		}
		
		private var _points:Vector.<BiomePoint>;
		
		private var _width:int;
		
		private var _height:int;
		
		private var _depth:int;
		
		
		public function BiomeBounds() {
			_points = new Vector.<BiomePoint>();
		}
		
		
		public function setArea(width:int, height:int, depth:int):void {
			_depth = depth || 1;
			_height = height || 1;
			_width = width || 1;
			_points = new Vector.<BiomePoint>();
			BiomeMath.iterateArea(0, 0, 0, width, height, depth, function(x:int, y:int, z:int):void {
					_points[_points.length] = new BiomePoint(x, y, z);
				});
		}
		
		
		public function updateArea():void {
			var ax:int = 0xFFFFFF;
			var bx:int = 0;
			var ay:int = 0xFFFFFF;
			var by:int = 0;
			var az:int = 0xFFFFFF;
			var bz:int = 0;
			iterate(function(point:BiomePoint):void {
					if (point.x < ax) {
						ax = point.x;
					} else if (point.x > bx) {
						bx = point.x;
					}
					if (point.y < ay) {
						ay = point.y;
					} else if (point.y > by) {
						by = point.y;
					}
					if (point.z < az) {
						az = point.z;
					} else if (point.z > bz) {
						bz = point.z;
					}
				});
			_width = bx - ax;
			_height = by - ay;
			_depth = bz - az;
		}
		
		
		public function get points():Vector.<BiomePoint> {
			return _points;
		}
		
		
		public function get width():int {
			return _width;
		}
		
		
		public function get height():int {
			return _height;
		}
		
		
		public function get depth():int {
			return _depth;
		}
		
		
		public function iterate(handler:Function):void {
			for each (var point:BiomePoint in _points) {
				handler(point);
			}
		}
		
		
		public function copyPoints():Vector.<BiomePoint> {
			return (new Vector.<BiomePoint>()).concat(_points);
		}
	
	}

}