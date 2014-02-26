package gate.sirius.isometric {
	
	import flash.utils.Dictionary;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeBox;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	import gate.sirius.isometric.math.BiomeMath;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.signal.BiomeColliderSignal;
	import gate.sirius.isometric.signal.BiomeEntrySignal;
	import gate.sirius.isometric.signal.BiomeFindSignal;
	import gate.sirius.isometric.signal.BiomeMatterSignal;
	import gate.sirius.signals.SignalDispatcher;
	
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Biome {
		
		/** @private */
		private var _gridBiome:Dictionary;
		
		/** @private */
		private var _neighbors:Dictionary;
		
		/** @private */
		private var _matterByName:Dictionary;
		
		/** @private */
		private var _matterLocation:Dictionary;
		
		/** @private */
		private var _matterBounds:Dictionary;
		
		/** @private */
		private var _isEnabled:Boolean;
		
		/** @private */
		private var _baseCost:int;
		
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
		private var _signals:SignalDispatcher;
		
		/** @private */
		private var _location:BiomeFlexPoint;
		
		/** @private */
		private var _viewBox:BiomeFlexPoint;
		
		/** @private */
		private function _expandVisionX():void {
			++_right;
			_checkBound(_top, _bottom, _front, _back, function(a:int, b:int):void {
					_showTile(_getTile(_right, a, b));
				});
		}
		
		/** @private */
		private function _reduceVisionX():void {
			_checkBound(_top, _bottom, _front, _back, function(a:int, b:int):void {
					_hideTile(_getTile(_right, a, b));
				});
			--_right;
		}
		
		/** @private */
		private function _expandVisionY():void {
			++_bottom;
			_checkBound(_left, _right, _front, _back, function(a:int, b:int):void {
					_showTile(_getTile(a, _bottom, b));
				});
		}
		
		/** @private */
		private function _reduceVisionY():void {
			_checkBound(_left, _right, _front, _back, function(a:int, b:int):void {
					_hideTile(_getTile(a, _bottom, b));
				});
			--_bottom;
		}
		
		/** @private */
		private function _expandVisionZ():void {
			++_back;
			_checkBound(_left, _right, _top, _bottom, function(a:int, b:int):void {
					_showTile(_getTile(a, b, _back));
				});
		}
		
		/** @private */
		private function _reduceVisionZ():void {
			_checkBound(_left, _right, _top, _bottom, function(a:int, b:int):void {
					_hideTile(_getTile(a, b, _back));
				});
			--_back;
		}
		
		/** @private */
		private function _getTile(x:int, y:int, z:int):BiomeEntry {
			var data:Dictionary = _gridBiome[z] ||= new Dictionary(true);
			data = data[y] ||= new Dictionary(true);
			return data[x] ||= _createEntry(x, y, z, data);
		}
		
		protected function _createEntry(x:int, y:int, z:int, data:Dictionary):BiomeEntry {
			var entry:BiomeEntry = new BiomeEntry(x, y, z, this);
			data[x] = entry;
			entry.create();
			return entry;
		}
		
		/** @private */
		private function _search(x:int, y:int, z:int):BiomeEntry {
			var r:Dictionary = _gridBiome[z];
			if (r) {
				r = r[y];
				if (r) {
					return r[x];
				}
			}
			return null;
		}
		
		/** @private */
		private function _showTile(tile:BiomeEntry):void {
			_signals.send(new BiomeEntrySignal(BiomeEntrySignal.SHOW, tile));
		}
		
		/** @private */
		private function _hideTile(tile:BiomeEntry):void {
			_signals.send(new BiomeEntrySignal(BiomeEntrySignal.HIDE, tile));
		}
		
		/** @private */
		private function _init(x:int = 0, y:int = 0, z:int = 0, w:int = 5, h:int = 5, d:int = 1):void {
			_gridBiome = new Dictionary(true);
			_neighbors = new Dictionary(true);
			_matterByName = new Dictionary(true);
			_matterLocation = new Dictionary(true);
			_matterBounds = new Dictionary(true);
			_location = new BiomeFlexPoint(x, y, z);
			_viewBox = new BiomeFlexPoint(1, 1, 1);
			createArea(_location, new BiomeBox(w, h, d), false);
		}
		
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
						_showTile(_getTile(x, y, z));
					}
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
		private function _clearCurrentView():void {
			BiomeMath.iterateArea(_location.x, _location.y, _location.z, _viewBox.x, _viewBox.y, _viewBox.z, function showTile(x:int, y:int, z:int):void {
					_hideTile(_search(x, y, z));
				});
		}
		
		/** @private */
		private function _addMatterOccupation(matter:BiomeMatter):void {
			var location:BiomeFlexPoint = matter.location.clone();
			var bounds:Vector.<BiomePoint> = matter.bounds.copyPoints()
			_matterLocation[matter.name] = location;
			_matterBounds[matter.name] = bounds;
			var tile:BiomeEntry;
			for each (var point:BiomePoint in bounds) {
				tile = _search(location.x + point.x, location.y + point.y, location.z + point.z);
				if (tile) {
					tile.occupation.push(matter);
				}
			}
			_signals.send(new BiomeMatterSignal(BiomeMatterSignal.ADDED, matter));
		}
		
		private function _removeMatterOccupation(matter:BiomeMatter):void {
			var location:BiomeFlexPoint = _matterLocation[matter.name];
			var points:Vector.<BiomePoint> = _matterBounds[matter.name];
			var tile:BiomeEntry;
			for each (var point:BiomePoint in points) {
				tile = _search(location.x + point.x, location.y + point.y, location.z + point.z);
				if (tile) {
					var occ:Vector.<BiomeMatter> = tile.occupation;
					occ.splice(occ.indexOf(matter), 1);
				}
			}
			_signals.send(new BiomeMatterSignal(BiomeMatterSignal.REMOVED, matter));
		}
		
		/**
		 * Create a new Biome instance
		 * @param	x			Start x location
		 * @param	y			Start y location
		 * @param	z			Start z location
		 * @param	width		Default width of view box
		 * @param	height		Default height of view box
		 * @param	depth		Default depth of view box
		 * @param	baseCost
		 */
		public function Biome(x:int = 0, y:int = 0, z:int = 0, width:int = 5, height:int = 5, depth:int = 5, baseCost:int = 0) {
			_baseCost = baseCost;
			_signals = new SignalDispatcher(this);
			_init(x, y, z, width, height, depth);
		}
		
		/**
		 * Add a new matter in Biome and register the occupation
		 * @param	matter
		 * @return
		 */
		public function addMatter(matter:BiomeMatter):BiomeMatter {
			if (!_matterByName[matter.name]) {
				_matterByName[matter.name] = matter;
				_addMatterOccupation(matter);
				matter.parent = this;
			}
			return matter;
		}
		
		/**
		 * Remove matter from Biome and clear all occupation, if exists
		 * @param	matter
		 * @return
		 */
		public function removeMatter(matter:BiomeMatter):BiomeMatter {
			if (_matterByName[matter.name]) {
				delete _matterByName[matter.name];
				matter.parent = null;
				_removeMatterOccupation(matter);
				delete _matterLocation[matter.name];
				delete _matterBounds[matter.name];
			}
			return matter;
		}
		
		/**
		 * Update a matter occupation in Biome
		 * @param	matter
		 */
		public function postMatter(matter:BiomeMatter):void {
			_removeMatterOccupation(matter);
			_addMatterOccupation(matter);
		}
		
		/**
		 * Get the all matter occupation from a location
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	count
		 * @return
		 */
		public function getMatterOfLocation(x:int, y:int, z:int, count:int = 0):Vector.<BiomeMatter> {
			var tile:BiomeEntry = _search(x, y, z);
			return tile && tile.occupation.length >= count ? tile.occupation : null;
		}
		
		/**
		 * Get all matters in a bound location
		 * @param	location
		 * @param	bounds
		 * @param	max
		 * @return
		 */
		public function getMatterOfBounds(location:BiomePoint, bounds:BiomeBounds, max:int = 0):Vector.<BiomeMatter> {
			var result:Vector.<BiomeMatter> = new Vector.<BiomeMatter>();
			main: for each (var point:BiomePoint in bounds.points) {
				var tile:BiomeEntry = _search(location.x + point.x, location.y + point.y, location.z + point.z);
				if (tile) {
					for each (var matter:BiomeMatter in tile.occupation) {
						if (result.indexOf(matter) == -1) {
							result[result.length] = matter;
							if (result.length == max) {
								break main;
							}
						}
					}
				}
			}
			return result;
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
					_hideTile(_getTile(_left, a, b));
					_showTile(_getTile(_right, a, b));
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
						_showTile(_getTile(_left, a, b));
						_hideTile(_getTile(_right, a, b));
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
						_hideTile(_getTile(a, _bottom, b));
						_showTile(_getTile(a, _top, b));
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
						_hideTile(_getTile(a, _top, b));
						_showTile(_getTile(a, _bottom, b));
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
						_hideTile(_getTile(a, b, _back));
						_showTile(_getTile(a, b, _front));
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
						_hideTile(_getTile(a, b, _front));
						_showTile(_getTile(a, b, _back));
					});
				++_front;
				--length;
			}
		
		}
		
		/**
		 * Get tile occupation from location
		 * @param	x
		 * @param	y
		 * @param	z
		 * @return
		 */
		public function getTile(x:int, y:int, z:int):BiomeEntry {
			return _search(x, y, z);
		}
		
		/**
		 * Get tile occupation from point
		 * @param	point
		 * @return
		 */
		public function getTileFromPoint(point:BiomePoint):BiomeEntry {
			return _search(point.x, point.y, point.z);
		}
		
		/**
		 * Get all occupation tiles from a custom area
		 * @param	point
		 * @param	width
		 * @param	height
		 * @param	depth
		 * @param	cost
		 * @param	create
		 */
		public function getOccupation(point:BiomePoint, width:int, height:int, depth:int, cost:int = 0, create:Boolean = false):void {
			var costOf:int;
			var tile:BiomeEntry;
			var biome:Biome = this;
			var handler:Function = create ? _getTile : _search;
			BiomeMath.iterateArea(point.x, point.y, point.z, width, height, depth, function(x:int, y:int, z:int):void {
					tile = handler(x, y, z);
					if (tile) {
						if (cost == 0 || (costOf = BiomeMath.costOfPointToPoint(tile.location, point)) <= cost) {
							_signals.send(new BiomeFindSignal(BiomeFindSignal.FIND, point, tile, costOf));
						}
					}
				});
		
		}
		
		public function colliderBeam(from:BiomePoint, direction:BiomePoint, limit:int = 999, filter:Function = null, create:Boolean = false):void {
			
			var i:int = 0;
			
			var mag:Number = direction.getMagnitude();
			
			var xs:Number = direction.x / mag;
			var ys:Number = direction.y / mag;
			var zs:Number = direction.z / mag;
			
			var x:int = from.x;
			var y:int = from.y;
			var z:int = from.z;
			
			var cx:Number = x;
			var cy:Number = y;
			var cz:Number = z;
			
			var prevtile:BiomeEntry = _search(from.x, from.y, from.z);
			
			var costOf:int;
			var tile:BiomeEntry;
			
			if (filter == null) {
				filter = function(tile:BiomeEntry, costOf:int):Boolean {
					return create || tile == null;
				};
			}
			
			var handler:Function = create ? _getTile : _search;
			
			while (i < limit) {
				
				cx += xs;
				cy += ys;
				cz += zs;
				
				trace(cx.toFixed(2), cy.toFixed(2), cz.toFixed(2), "---------------", xs.toFixed(2), ys.toFixed(2), zs.toFixed(2));
				
				++i;
				
				if (int(cx) !== x || int(cy) !== y || int(cz) !== z) {
					x = cx;
					y = cy;
					z = cz;
					
					tile = handler(x, y, z);
					if (tile) {
						costOf = BiomeMath.costOfPointToPoint(from, tile.location);
						if (filter(tile, costOf)) {
							_signals.send(new BiomeColliderSignal(BiomeColliderSignal.PATH, from, tile, costOf));
							prevtile = tile;
							continue;
						}
					}
					
					break;
				}
				
			}
			
			_signals.send(new BiomeColliderSignal(BiomeColliderSignal.COLLISION, from, prevtile, costOf));
		
		}
		
		/**
		 * Create a biome area without move location
		 * @param	point
		 * @param	width
		 * @param	height
		 * @param	depth
		 */
		public function createArea(point:BiomePoint, box:BiomeBox, show:Boolean = false):void {
			BiomeMath.iterateArea(point.x, point.y, point.z, box.width, box.height, box.depth, show ? function(x:int, y:int, z:int):void {
					_showTile(_getTile(x, y, z));
				} : _getTile);
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
			var handler:Function = create ? _getTile : _search;
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
					tile = _search(x, y, z);
					if (tile) {
						if (cost == 0 || (costOf = BiomeMath.costOfPointToPoint(tile.location, point)) <= cost) {
							_hideTile(tile);
						}
					}
				});
		}
		
		/**
		 * Reset all biome data
		 */
		public function clear():void {
			_signals.reset();
			_init();
		}
		
		/**
		 * Signal dispatcher
		 */
		public function get signals():SignalDispatcher {
			return _signals;
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
	
	}

}