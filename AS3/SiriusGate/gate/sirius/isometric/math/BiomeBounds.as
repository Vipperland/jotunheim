package gate.sirius.isometric.math {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeBounds {
		
		public static const NONE:int = 0;
		
		public static const WIDTH_HEIGHT:int = 1;
		
		public static const WIDTH_DEPTH:int = 2;
		
		public static const DEPTH_HEIGHT:int = 4;
		
		/**
		 * Create a BiomeBounds instance
		 * @param	width
		 * @param	height
		 * @param	depth
		 * @return
		 */
		static public function BOX(width:int, height:int, depth:int):BiomeBounds {
			return new BiomeBounds().setArea(width, height, depth);
		}
		
		/**
		 * 010;101;010	0=Empty, 1=Tile
		 * @param	value
		 * @return
		 */
		static public function STRING(value:String):BiomeBounds {
			var grid:Array = value.split(";");
			for (var r:String in grid) {
				grid[r] = grid[r].split("");
			}
			return PATERN(grid);
		}
		
		/**
		 * Y-X Map [[0,1,0],[1,0,1],[0,1,0]] 0=Empty, 1=Tile
		 * @param	grid
		 * @return
		 */
		static public function PATERN(grid:Array):BiomeBounds {
			var y:int, x:int, tx:int, r:Array;
			var ty:int = grid.length;
			var b:BiomeBounds = new BiomeBounds();
			var p:Vector.<BiomePoint> = b._points;
			while (y < ty) {
				x = 0;
				r = grid[y];
				tx = r.length;
				while (x < tx) {
					if (r[x] !== 0) {
						p[p.length] = BiomePoint.create(x, y, 0);
					}
					++x;
				}
				++y;
			}
			return b.updateArea();
		}
		
		/** @private */
		private var _points:Vector.<BiomePoint>;
		
		/** @private */
		private var _width:int;
		
		/** @private */
		private var _height:int;
		
		/** @private */
		private var _depth:int;
		
		/** @private */
		private var _fwidth:int;
		
		/** @private */
		private var _fheight:int;
		
		/** @private */
		private var _fdepth:int;
		
		/** @private */
		private var _prevent:Boolean;
		
		/**
		 * Create a BiomeBounds instance
		 */
		public function BiomeBounds(... points:Array) {
			_points = Vector.<BiomePoint>(points);
			if (_points.length > 0) {
				updateArea();
			}
		}
		
		/**
		 * Auto create an area
		 * @param	width
		 * @param	height
		 * @param	depth
		 * @return
		 */
		public function setArea(width:int, height:int, depth:int):BiomeBounds {
			_depth = depth || 1;
			_height = height || 1;
			_width = width || 1;
			_fwidth = _width;
			_fheight = _height;
			_depth = _depth;
			_points = new Vector.<BiomePoint>();
			BiomeMath.iterateArea(0, 0, 0, width, height, depth, function(x:int, y:int, z:int):void {
					_points[_points.length] = BiomePoint.create(x, y, z);
				});
			return this;
		}
		
		/**
		 * Update width, height and depth
		 * @return
		 */
		public function updateArea():BiomeBounds {
			var ax:int = int.MAX_VALUE;
			_fwidth = 0;
			var ay:int = int.MAX_VALUE;
			_fheight = 0;
			var az:int = int.MAX_VALUE;
			_fdepth = 0;
			iterate(function(point:BiomePoint):void {
					if (point.x < ax) {
						ax = point.x;
					} else if (point.x > _fwidth) {
						_fwidth = point.x;
					}
					if (point.y < ay) {
						ay = point.y;
					} else if (point.y > _fheight) {
						_fheight = point.y;
					}
					if (point.z < az) {
						az = point.z;
					} else if (point.z > _fdepth) {
						_fdepth = point.z;
					}
				});
			_width = _fwidth - ax;
			_height = _fheight - ay;
			_depth = _fdepth - az;
			++_width;
			++_height;
			++_depth;
			return this;
		}
		
		/**
		 * Occupation locations
		 */
		public function get points():Vector.<BiomePoint> {
			return _points;
		}
		
		/**
		 * Total width of the area
		 */
		public function get width():int {
			return _width;
		}
		
		/**
		 * Total height of the area
		 */
		public function get height():int {
			return _height;
		}
		
		/**
		 * Total depth of the area
		 */
		public function get depth():int {
			return _depth;
		}
		
		/**
		 * Distance of x:0
		 */
		public function get maxX():int {
			return _fwidth;
		}
		
		/**
		 * Distance of y:0
		 */
		public function get maxY():int {
			return _fheight;
		}
		
		/**
		 * Distance of z:0
		 */
		public function get maxZ():int {
			return _fdepth;
		}
		
		/**
		 * Stop current iteration
		 */
		public function prevent():void {
			_prevent = true;
		}
		
		/**
		 * Call a method for each point
		 * @param	handler
		 */
		public function iterate(handler:Function):void {
			_prevent = false;
			for each (var point:BiomePoint in _points) {
				handler(point);
				if (_prevent) {
					_prevent = false;
					return;
				}
			}
		}
		
		/**
		 * Add a new point
		 * @param	point
		 */
		public function addPoint(point:BiomePoint):void {
			_points[_points.length] = point;
		}
		
		/**
		 * Add a point list
		 * @param	point
		 */
		public function addPoints(points:Vector.<BiomePoint>):void {
			_points = _points.concat(points);
		}
		
		/**
		 * Create a copy of current points
		 * @return
		 */
		public function copyPoints():Vector.<BiomePoint> {
			return (new Vector.<BiomePoint>()).concat(_points);
		}
		
		/**
		 * Create a custom clone of current bounds
		 * @param options
		 * @return
		 */
		public function clone(options:uint = 0):BiomeBounds {
			var bounds:BiomeBounds = new BiomeBounds();
			var points:Vector.<BiomePoint> = bounds._points;
			switch (options) {
				case WIDTH_HEIGHT:  {
					iterate(function(point:BiomePoint):void {
							points[points.length] = BiomePoint.create(point._y, point._x, point._z);
						})
					break;
				}
				case WIDTH_DEPTH:  {
					iterate(function(point:BiomePoint):void {
							points[points.length] = BiomePoint.create(point._z, point._y, point._x);
						})
					break;
				}
				case DEPTH_HEIGHT:  {
					iterate(function(point:BiomePoint):void {
							points[points.length] = BiomePoint.create(point._x, point._z, point._y);
						})
					break;
				}
				default:  {
					points = points.concat(_points);
				}
			
			}
			return bounds;
		}
		
		public function toString():String {
			return "[BiomeBounds (width:" + _width + ", height:" + _height + ", depth:" + _depth + ", x:" + _fwidth + ", y:" + _fheight + ", z:" + _fdepth + ")]";
		}
	
	}

}