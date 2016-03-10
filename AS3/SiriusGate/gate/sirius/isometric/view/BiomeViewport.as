package gate.sirius.isometric.view {
	
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.math.BiomeBox;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	import gate.sirius.isometric.math.BiomeMath;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.signal.BiomeEntrySignal;
	
	/**
	 * ...
	 * @author asdasd
	 */
	public class BiomeViewport {
		
		/** @private */
		private var _biome:Biome;
		
		/** @private */
		private var _left:int;
		
		/** @private */
		private var _right:int;
		
		/** @private */
		private var _top:int;
		
		/** @private */
		private var _bottom:int;
		
		/** @private */
		private var _front:int;
		
		/** @private */
		private var _back:int;
		
		/** @private */
		private var _location:BiomeFlexPoint;
		
		/** @private */
		private var _viewBox:BiomeFlexPoint;
		
		/** @private */
		private var _visibleTiles:Vector.<BiomeEntry>;
		
		/** @private */
		private var _baseCost:uint;
		
		/** @private */
		private var _isEnabled:Boolean;
		
		/** @private */
		private var _chunkBaseSize:BiomeBox;
		
		/** @private */
		private function _showCurrentView():void {
			
			_left = _location.x;
			_right = _location.x + _viewBox.x;
			
			_top = _location.y;
			_bottom = _location.y + _viewBox.y;
			
			_front = _location.z;
			_back = _location.z + _viewBox.z;
			
			BiomeMath.iterateArea(_location.x, _location.y, _location.z, _viewBox.x, _viewBox.y, _viewBox.z, function showTile(x:int, y:int, z:int):void {
					if (_baseCost == 0 || BiomeMath.costOfPointToLocation(_location, x, y, z) <= _baseCost) {
						_showTile(_biome.searchTile(x, y, z));
					}
				});
		
		}
		
		/** @private */
		private function _clearCurrentView():void {
			BiomeMath.iterateArea(_location.x, _location.y, _location.z, _viewBox.x, _viewBox.y, _viewBox.z, function showTile(x:int, y:int, z:int):void {
					_hideTile(_biome.searchTile(x, y, z));
				});
		}
		
		/** @private */
		protected function _viewBoxSizeChange(width:int, height:int, depth:int):void {
			var rWidth:int = width - _viewBox.x;
			var rHeight:int = height - _viewBox.y;
			var rDepth:int = depth - _viewBox.z;
			if (rWidth !== 0 && _viewBox.x !== 0) {
				while (rWidth < 0) {
					_reduceVisionX();
					++rWidth;
				}
				while (rWidth > 0) {
					_expandVisionX();
					--rWidth;
				}
			}
			
			if (rHeight !== 0 && _viewBox.y !== 0) {
				while (rHeight < 0) {
					_reduceVisionY();
					++rHeight;
				}
				while (rHeight > 0) {
					_expandVisionY();
					--rHeight;
				}
			}
			
			if (rDepth !== 0 && _viewBox.z !== 0) {
				while (rDepth < 0) {
					_reduceVisionZ();
					++rDepth;
				}
				while (rDepth > 0) {
					_expandVisionZ();
					--rDepth;
				}
			}
		}
		
		/** @private */
		private function _expandVisionX():void {
			++_right;
			_checkBound(_top, _bottom, _front, _back, function(a:int, b:int):void {
					_showTile(_biome.getTile(_right, a, b));
				});
		}
		
		/** @private */
		private function _reduceVisionX():void {
			_checkBound(_top, _bottom, _front, _back, function(a:int, b:int):void {
					_hideTile(_biome.getTile(_right, a, b));
				});
			--_right;
		}
		
		/** @private */
		private function _expandVisionY():void {
			++_bottom;
			_checkBound(_left, _right, _front, _back, function(a:int, b:int):void {
					_showTile(_biome.getTile(a, _bottom, b));
				});
		}
		
		/** @private */
		private function _reduceVisionY():void {
			_checkBound(_left, _right, _front, _back, function(a:int, b:int):void {
					_hideTile(_biome.getTile(a, _bottom, b));
				});
			--_bottom;
		}
		
		/** @private */
		private function _expandVisionZ():void {
			++_back;
			_checkBound(_left, _right, _top, _bottom, function(a:int, b:int):void {
					_showTile(_biome.getTile(a, b, _back));
				});
		}
		
		/** @private */
		private function _reduceVisionZ():void {
			_checkBound(_left, _right, _top, _bottom, function(a:int, b:int):void {
					_hideTile(_biome.getTile(a, b, _back));
				});
			--_back;
		}
		
		/** @private */
		private function _checkBound(a:int, b:int, c:int, d:int, handler:Function):void {
			if (!_isEnabled) {
				return;
			}
			var p:int = c;
			++b;
			++d;
			while (a < b) {
				while (p < d) {
					handler(a, p);
					++p;
				}
				p = c;
				++a;
			}
		
		}
		
		/** @private */
		public function _showTile(tile:BiomeEntry):void {
			if (tile) {
				_visibleTiles[_visibleTiles.length] = tile;
				_biome.signals.TILE_SHOW.send(BiomeEntrySignal, true, tile);
			}
		}
		
		/** @private */
		public function _hideTile(tile:BiomeEntry):void {
			if (tile) {
				_visibleTiles.splice(_visibleTiles.indexOf(tile), 1);
				_biome.signals.TILE_HIDE.send(BiomeEntrySignal, true, tile);
			}
		}
		
		public function BiomeViewport(x:int, y:int, z:int, w:uint, h:uint, d:uint, biome:Biome) {
			_biome = biome;
			_location = new BiomeFlexPoint(x, y, z);
			_viewBox = new BiomeFlexPoint(w, h, d);
			_visibleTiles = new Vector.<BiomeEntry>();
			_chunkBaseSize = new BiomeBox(10, 10, 10);
			_baseCost = 5;
			if (w + h + d > 0) {
				createArea(location, new BiomeBox(w, h, d), false);
			}
		}
		
		/**
		 * Returns the copy of current location on grid
		 */
		public function get location():BiomeFlexPoint {
			return _location.clone();
		}
		
		/**
		 * Returns the copy of current view box size
		 */
		public function get viewBox():BiomeFlexPoint {
			return _viewBox.clone();
		}
		
		/**
		 * List of all visible tile in logic viewport
		 */
		public function get visibleTiles():Vector.<BiomeEntry> {
			return _visibleTiles;
		}
		
		/**
		 * Default range of search
		 */
		public function get baseCost():uint {
			return _baseCost;
		}
		
		public function set baseCost(value:uint):void {
			_baseCost = value;
		}
		
		/**
		 * Move to a location
		 * @param	x
		 * @param	y
		 * @param	z
		 */
		public function moveToLocation(x:int, y:int, z:int):void {
			if (_isEnabled) {
				_clearCurrentView();
			}
			_location.moveToLocation(x, y, z);
			if (_isEnabled) {
				_showCurrentView();
			}
		}
		
		/**
		 * Move to a point location
		 * @param	point
		 */
		public function moveToPoint(point:BiomePoint):void {
			moveToLocation(point.x, point.y, point.z);
		}
		
		/**
		 * Change size of view box and creates missing tiles in view
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	cost
		 */
		public function changeViewBoxBy(x:int, y:int, z:int):void {
			setViewBox(_viewBox.x + x, _viewBox.y + y, _viewBox.z + z);
		}
		
		/**
		 * Decrease or increase view box size
		 * @param	width
		 * @param	height
		 * @param	depth
		 */
		public function setViewBox(width:int, height:int, depth:int):void {
			if (_isEnabled) {
				_viewBoxSizeChange(width, height, depth);
			}
			
			_viewBox.moveToLocation(width, height, depth);
		}
		
		/**
		 * Create a biome area without move location
		 * @param	point
		 * @param	width
		 * @param	height
		 * @param	depth
		 */
		public function createArea(point:BiomePoint, box:BiomeBox, show:Boolean = false):void {
			var getTile:Function = _biome.getTile;
			BiomeMath.iterateArea(point.x, point.y, point.z, box.width, box.height, box.depth, show ? function(x:int, y:int, z:int):void {
					_showTile(getTile(x, y, z));
				} : _biome.getTile);
		}
		
		/**
		 * Show a custom area
		 * @param	point
		 * @param	width
		 * @param	height
		 * @param	depth
		 * @param	cost
		 * @param	create
		 */
		public function showArea(point:BiomePoint, box:BiomeBox, cost:int = 0, create:Boolean = false):void {
			var costOf:int;
			var tile:BiomeEntry;
			var handler:Function = create ? _biome.getTile : _biome.searchTile;
			BiomeMath.iterateArea(point.x, point.y, point.z, box.width, box.height, box.depth, function(x:int, y:int, z:int):void {
					tile = handler(x, y, z);
					if (tile) {
						if (cost == 0 || (costOf = BiomeMath.costOfPointToPoint(tile.location, point)) <= cost) {
							_showTile(tile);
						}
					}
				});
		}
		
		/**
		 * get an area entry
		 * @param	point
		 * @param	box
		 * @return
		 */
		public function getArea(point:BiomePoint, box:BiomeBox, create:Boolean = false):Vector.<BiomeEntry> {
			var tile:BiomeEntry;
			var handler:Function = create ? _biome.getTile : _biome.searchTile;
			var result:Vector.<BiomeEntry> = new Vector.<BiomeEntry>();
			BiomeMath.iterateArea(point.x, point.y, point.z, box.width, box.height, box.depth, function(x:int, y:int, z:int):void {
					tile = handler(x, y, z);
					if (tile) {
						result[result.length] = tile;
					}
				});
			return result;
		}
		
		/**
		 * Hide an entire area
		 * @param	point
		 * @param	width
		 * @param	height
		 * @param	depth
		 */
		public function hideArea(point:BiomePoint, box:BiomeBox, cost:int = 0):void {
			var costOf:int;
			var tile:BiomeEntry;
			BiomeMath.iterateArea(point.x, point.y, point.z, box.width, box.height, box.depth, function(x:int, y:int, z:int):void {
					tile = _biome.searchTile(x, y, z);
					if (tile) {
						if (cost == 0 || (costOf = BiomeMath.costOfPointToPoint(tile.location, point)) <= cost) {
							_hideTile(tile);
						}
					}
				});
		}
		
		/**
		 * Start the creation of all missing tiles when current position changes
		 */
		public function startDraw():void {
			_isEnabled = true;
			_showCurrentView();
		}
		
		/**
		 * Stop all tile creation
		 */
		public function stopDraw():void {
			_isEnabled = false;
			_clearCurrentView();
		}
		
		/**
		 * Move view box to right
		 * @param	length
		 */
		public function moveRight(length:int = 1):void {
			_location.moveRight();
			++_right
			_checkBound(_top, _bottom, _front, _back, function(a:int, b:int):void {
					_hideTile(_biome.searchTile(_left, a, b));
					_showTile(_biome.searchTile(_right, a, b));
				});
			++_left;
			if (--length > 0) {
				moveRight(length);
			}
		}
		
		/**
		 * Move view box to left
		 * @param	length
		 */
		public function moveLeft(length:int = 1):void {
			while (length > 0) {
				_location.moveLeft();
				--_left;
				_checkBound(_top, _bottom, _front, _back, function(a:int, b:int):void {
						_showTile(_biome.searchTile(_left, a, b));
						_hideTile(_biome.searchTile(_right, a, b));
					});
				--_right;
				--length;
			}
		}
		
		/**
		 * Move view box up
		 * @param	length
		 */
		public function moveUp(length:int = 1):void {
			while (length > 0) {
				_location.moveUp();
				--_top;
				_checkBound(_left, _right, _front, _back, function(a:int, b:int):void {
						_hideTile(_biome.searchTile(a, _bottom, b));
						_showTile(_biome.searchTile(a, _top, b));
					});
				--_bottom;
				--length;
			}
		}
		
		/**
		 * Move view box down
		 * @param	length
		 */
		public function moveDown(length:int = 1):void {
			while (length > 0) {
				_location.moveDown();
				++_bottom;
				_checkBound(_left, _right, _front, _back, function(a:int, b:int):void {
						_hideTile(_biome.searchTile(a, _top, b));
						_showTile(_biome.searchTile(a, _bottom, b));
					});
				++_top;
				--length;
			}
		}
		
		/**
		 * Move view box to front
		 * @param	length
		 */
		public function moveFront(length:int = 1):void {
			while (length > 0) {
				_location.moveFront();
				--_front;
				_checkBound(_left, _right, _top, _bottom, function(a:int, b:int):void {
						_hideTile(_biome.searchTile(a, b, _back));
						_showTile(_biome.searchTile(a, b, _front));
					});
				--_back;
				--length;
			}
		}
		
		/**
		 * Move view box to back
		 * @param	length
		 */
		public function moveBack(length:int = 1):void {
			while (length > 0) {
				_location.moveBack();
				++_back;
				_checkBound(_left, _right, _top, _bottom, function(a:int, b:int):void {
						_hideTile(_biome.searchTile(a, b, _front));
						_showTile(_biome.searchTile(a, b, _back));
					});
				++_front;
				--length;
			}
		
		}
		
		/**
		 * Check if tile is in visible area
		 * @param	biomeEntry
		 * @return
		 */
		public function isTileVisible(tile:BiomeEntry):Boolean {
			return _visibleTiles.indexOf(tile) !== -1;
		}
		
		/**
		 * Show an area base on a Chunck data
		 * @param	location
		 */
		public function showChunk(location:BiomePoint):void {
			showArea(BiomePoint.create(location.x * _chunkBaseSize.width, location.y * _chunkBaseSize.height, location.x * _chunkBaseSize.depth), _chunkBaseSize, 0, true);
		}
		
		/**
		 * Hide an area base on a Chunck data
		 * @param	location
		 */
		public function hideChunk(location:BiomePoint):void {
			hideArea(BiomePoint.create(location.x * _chunkBaseSize.width, location.y * _chunkBaseSize.height, location.x * _chunkBaseSize.depth), _chunkBaseSize, 0);
		}
		
		/**
		 * Create an area base on a Chunck data
		 * @param	location
		 */
		public function createChunk(location:BiomePoint):void {
			createArea(BiomePoint.create(location.x * _chunkBaseSize.width, location.y * _chunkBaseSize.height, location.x * _chunkBaseSize.depth), _chunkBaseSize, false);
		}
		
		/**
		 * Current chunck size for small to large area manipulation
		 */
		public function get chunkBaseSize():BiomeBox {
			return _chunkBaseSize;
		}
		
	
	}

}