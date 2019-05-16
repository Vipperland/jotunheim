package gate.sirius.isometric {
	
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeMath;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.matter.BiomeActivations;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.matter.OrganicBiomeMatter;
	import gate.sirius.isometric.signal.BiomeColliderSignal;
	import gate.sirius.isometric.signal.BiomeMatterSignal;
	import gate.sirius.isometric.signal.BiomeSignals;
	import gate.sirius.isometric.timer.BiomeHeart;
	import gate.sirius.isometric.tools.BiomeInteraction;
	import gate.sirius.isometric.view.BiomeCommunity;
	import gate.sirius.isometric.view.BiomeViewport;
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Biome {
		
		/** @private */
		private var _heart:BiomeHeart;
		
		/** @private */
		private var _viewport:BiomeViewport;
		
		/** @private */
		private var _community:BiomeCommunity;
		
		/** @private */
		private var _gridBiome:Array;
		
		/** @private */
		private var _matterByName:Dictionary;
		
		/** @private */
		private var _matterLocation:Dictionary;
		
		/** @private */
		private var _matterBounds:Dictionary;
		
		/** @private */
		private var _signals:BiomeSignals;
		
		/** @private */
		private var _cursor:BiomeInteraction;
		
		/** Create missing tiles */
		public var alwaysCreateTiles:Boolean;
		
		
		/** @private */
		private function _disableInteraction():void {
			_cursor = null;
		}
		
		
		/** @private */
		protected function _createEntry(x:int, y:int, z:int, data:Dictionary):BiomeEntry {
			var entry:BiomeEntry = new BiomeEntry(x, y, z, this);
			data[x] = entry;
			entry.create();
			return entry;
		}
		
		
		/**
		 * Get entry value from location (will create a new one if not found)
		 * @param	location
		 * @return
		 */
		public function getTileIn(location:BiomePoint):BiomeEntry {
			return getTile(location.x, location.y, location.z);
		}
		
		
		/**
		 * Get entry value (will create a new one if not found)
		 * @param	x
		 * @param	y
		 * @param	z
		 * @return
		 */
		public function getTile(x:int, y:int, z:int):BiomeEntry {
			var data:Dictionary = _gridBiome[z] ||= new Dictionary(true);
			data = data[y] ||= new Dictionary(true);
			return data[x] ||= _createEntry(x, y, z, data);
		}
		
		
		/**
		 * Search a valid entry
		 * @param	x
		 * @param	y
		 * @param	z
		 * @return
		 */
		public function searchTile(x:int, y:int, z:int):BiomeEntry {
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
		private function _init(x:int = 0, y:int = 0, z:int = 0, w:int = 5, h:int = 5, d:int = 1, fps:int = 60):void {
			_gridBiome = [];
			_matterByName = new Dictionary(true);
			_matterLocation = new Dictionary(true);
			_matterBounds = new Dictionary(true);
			_heart = BiomeHeart.ME;
			_signals = new BiomeSignals(this);
			_viewport = new BiomeViewport(x, y, z, w, h, d, this);
			_community = new BiomeCommunity(this);
		}
		
		
		/** @private */
		private function _addMatterOccupation(matter:BiomeMatter):void {
			var location:BiomePoint = matter.location.cloneStatic();
			var bounds:Vector.<BiomePoint> = matter.allocation.current.copyPoints();
			_matterLocation[matter.name] = location;
			_matterBounds[matter.name] = bounds;
			var tile:BiomeEntry;
			var handler:Function = alwaysCreateTiles ? getTile : searchTile;
			for each (var point:BiomePoint in bounds) {
				tile = handler(location.x + point.x, location.y + point.y, location.z + point.z);
				if (tile) {
					tile.occupation.push(matter);
				}
			}
		}
		
		
		/** @private */
		private function _removeMatterOccupation(matter:BiomeMatter):void {
			var location:BiomePoint = _matterLocation[matter.name];
			var points:Vector.<BiomePoint> = _matterBounds[matter.name];
			var tile:BiomeEntry;
			for each (var point:BiomePoint in points) {
				tile = searchTile(location.x + point.x, location.y + point.y, location.z + point.z);
				if (tile) {
					var occ:Vector.<BiomeMatter> = tile.occupation;
					occ.splice(occ.indexOf(matter), 1);
				}
			}
		}
		
		
		/**
		 * Create a new Biome instance
		 * @param	x			Start x location
		 * @param	y			Start y location
		 * @param	z			Start z location
		 * @param	width		Default width of view box
		 * @param	height		Default height of view box
		 * @param	depth		Default depth of view box
		 * @param	createTiles
		 */
		public function Biome(x:int = 0, y:int = 0, z:int = 0, width:int = 5, height:int = 5, depth:int = 5, createTiles:Boolean = true, fps:int = 60) {
			_init(x, y, z, width, height, depth, fps);
			alwaysCreateTiles = createTiles;
		}
		
		
		/**
		 * Add a new matter in Biome and register the occupation
		 * @param	matter
		 * @return
		 */
		public function addMatter(matter:BiomeMatter):BiomeMatter {
			if (_matterByName[matter.name]) {
				throw new Error("Matter::[" + matter.name + "] already registered.");
				return null;
			}
			_matterByName[matter.name] = matter;
			matter.parent = this;
			_addMatterOccupation(matter);
			var omatter:OrganicBiomeMatter = matter as OrganicBiomeMatter;
			if (omatter) {
				_heart.connect(omatter);
			}
			_signals.MATTER_ADDED.send(BiomeMatterSignal, true, matter);
			matter.activate(BiomeActivations.ADDED, null, this);
			return matter;
		}
		
		
		/**
		 * Remove matter from Biome and clear all occupation, if exists
		 * @param	matter
		 * @return
		 */
		public function removeMatter(matter:BiomeMatter):BiomeMatter {
			if (_matterByName[matter.name]) {
				matter.cancelPendingActivation();
				matter.activate(BiomeActivations.REMOVED, null, this);
				_signals.MATTER_REMOVED.send(BiomeMatterSignal, true, matter);
				delete _matterByName[matter.name];
				_removeMatterOccupation(matter);
				matter.parent = null;
				delete _matterLocation[matter.name];
				delete _matterBounds[matter.name];
				var omatter:OrganicBiomeMatter = matter as OrganicBiomeMatter;
				if (omatter) {
					_heart.disconnect(omatter);
				}
			}
			return matter;
		}
		
		
		/**
		 * Get a Matter registered by name
		 * @param	name
		 * @return
		 */
		public function getMatterByName(name:String):BiomeMatter {
			return _matterByName[name];
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
		 * Revert a matter occupation in Biome to last posted state
		 * @param	matter
		 */
		private function revertMatter(matter:BiomeMatter):void {
			matter.location.moveToPoint(_matterLocation[matter.name] || matter.location);
			matter.allocation.find(_matterBounds[matter.name]);
		}
		
		
		/**
		 * Get the all matter occupation from a location
		 * @param	location
		 * @param	count
		 * @return
		 */
		public function getMatterOfLocation(location:BiomePoint, count:int = 0):Vector.<BiomeMatter> {
			var tile:BiomeEntry = searchTile(location.x, location.y, location.z);
			return tile && tile.occupation.length >= count ? tile.occupation : null;
		}
		
		
		/**
		 * Get all matters in a bound location
		 * @param	location
		 * @param	bounds
		 * @param	max
		 * @return
		 */
		public function getOccupation(location:BiomePoint, bounds:BiomeBounds, max:int = 0, skip:BiomeMatter = null, filter:Function = null):Vector.<BiomeMatter> {
			var result:Vector.<BiomeMatter> = new Vector.<BiomeMatter>();
			var filtered:Dictionary = new Dictionary(true);
			main: for each (var point:BiomePoint in bounds.points) {
				var tile:BiomeEntry = searchTile(location.x + point.x, location.y + point.y, location.z + point.z);
				if (tile) {
					for each (var matter:BiomeMatter in tile.occupation) {
						if (skip == matter) {
							continue;
						}
						if (!filtered[matter.name]) {
							filtered[matter.name] = true;
							if (filter == null || filter(matter)) {
								result[result.length] = matter;
								if (result.length == max) {
									break main;
								}
							}
						}
					}
				}
			}
			return result;
		}
		
		
		/**
		 * Scan Z-axys for matters
		 * @param	mouseX
		 * @param	mouseY
		 * @param	tileWidth
		 * @param	tileHeight
		 * @param	startZ
		 * @param	maxElements
		 * @return
		 */
		public function depthScan(x:int, y:int, start:int, end:int, ocuppiedOnly:Boolean = true):Vector.<BiomeMatter> {
			
			var result:Vector.<BiomeMatter> = new Vector.<BiomeMatter>();
			var tile:BiomeEntry;
			var st:int = start;
			var en:int = end;
			var rv:Boolean;
			
			if (end < start) {
				st = end;
				en = start;
				rv = true;
			}
			
			while (st < en) {
				tile = searchTile(x, y, st);
				if (tile) {
					if (!ocuppiedOnly || tile.occupation.length > 0) {
						for each (var matter:BiomeMatter in tile.occupation) {
							if (result.indexOf(matter) == -1) {
								result[result.length] = matter;
							}
						}
					}
				}
				++st;
			}
			
			return rv ? result.reverse() : result;
		
		}
		
		
		public function collider(from:BiomePoint, direction:BiomePoint, limit:int = 999, filter:Function = null, create:Boolean = false):void {
			
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
			
			var prevtile:BiomeEntry = searchTile(from.x, from.y, from.z);
			
			var costOf:int;
			var tile:BiomeEntry;
			
			if (filter == null) {
				filter = function(tile:BiomeEntry, costOf:int):Boolean {
					return create || tile == null;
				};
			}
			
			var handler:Function = create ? getTile : searchTile;
			while (i < limit) {
				cx += xs;
				cy += ys;
				cz += zs;
				++i;
				if ((cx >> 0) !== x || (cy >> 0) !== y || (cz >> 0) !== z) {
					x = cx;
					y = cy;
					z = cz;
					tile = handler(x, y, z);
					if (tile) {
						costOf = BiomeMath.costOfPointToPoint(from, tile.location);
						if (filter(tile, costOf)) {
							_signals.COLLIDER_PATH.send(BiomeColliderSignal, true, from, tile, costOf);
							prevtile = tile;
							continue;
						}
					}
					break;
				}
			}
			
			_signals.COLLIDER_END.send(BiomeColliderSignal, true, from, prevtile, costOf);
		
		}
		
		
		/**
		 * Check if matter is visible
		 * @param	biomeMatter
		 */
		public function isMatterVisible(biomeMatter:BiomeMatter):void {
		
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
		public function get signals():BiomeSignals {
			return _signals;
		}
		
		
		/**
		 * Default Biome Heart for alive objects and timed behaviours
		 */
		public function get heart():BiomeHeart {
			return _heart;
		}
		
		
		/**
		 * Execute a method for each registered Matter
		 * @param	handler
		 */
		public function iterateMatter(handler:Function):void {
			for each (var matter:BiomeMatter in _matterByName) {
				handler(matter);
			}
		}
		
		
		/**
		 * Interaction Controller
		 * Only available after biome.enableInteraction()
		 */
		public function get cursor():BiomeInteraction {
			return _cursor;
		}
		
		
		/**
		 * Logic Tile manageament
		 */
		public function get viewport():BiomeViewport {
			return _viewport;
		}
		
		
		/**
		 * Controls large group of objects
		 */
		public function get community():BiomeCommunity {
			return _community;
		}
		
		
		/**
		 * Allow Cursor Interaction into Biome Matter
		 * @param	stage
		 */
		public function enableInteracion(stage:Stage, maxObjects:uint = 0):void {
			_cursor = new BiomeInteraction(stage, this, _disableInteraction, maxObjects);
		}
	
	}

}