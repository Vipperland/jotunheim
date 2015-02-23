package gate.sirius.isometric.matter {
	
	import flash.display.DisplayObject;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	import gate.sirius.isometric.behaviours.MatterBehaviours;
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.data.BiomeNeighbor;
	import gate.sirius.isometric.math.BiomeAllocation;
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.recycler.IRecyclable;
	import gate.sirius.isometric.recycler.Recycler;
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeMatter implements IBiomeMatter {
		
		/** @private */
		private var _delayedCall:uint;
		
		/** @private */
		public static var MATTER_COUNT:int = 0;
		
		/** @private */
		protected var _allocation:BiomeAllocation;
		
		/** @private */
		protected var _name:String;
		
		/** @private */
		protected var _parent:Biome;
		
		/** @private */
		protected var _location:BiomeFlexPoint;
		
		/** @private */
		protected var _content:DisplayObject;
		
		/** @private */
		protected var _tile:BiomeEntry;
		
		/** @private */
		protected var _behaviours:MatterBehaviours;
		
		/** @private */
		protected var _depthInfo:DepthInfo;
		
		/**
		 * Allow Cursor inetractions
		 */
		public var interaction:Boolean = true;
		
		
		/** @private */
		private function _activateNeighborsDelayer(hash:uint, closed:Vector.<BiomeMatter>, phase:uint, level:uint, data:*, from:BiomeMatter, filter:Function, delay:uint):void {
			if (delay == 0) {
				_activateNeighbors(hash, closed, phase, level, data, from, filter, delay, null);
			} else {
				_delayedCall = setTimeout(_activateNeighbors, delay, hash, closed, phase, level, data, from, filter, delay, null);
			}
		}
		
		
		private function _activateNeighbors(hash:uint, closed:Vector.<BiomeMatter>, phase:uint, level:uint, data:*, from:BiomeMatter, filter:Function, delay:uint, near:BiomeBounds):void {
			cancelPendingActivation();
			var neigbor:BiomeMatter;
			if (closed.indexOf(this) == -1) {
				if (from !== this) {
					if (filter !== null) {
						if (!filter(from, this)) {
							return;
						}
					}
					activate(phase, from, data);
				}
				if (level > 0) {
					--level;
					closed[closed.length] = this;
					if ((hash & BiomeNeighbor.RIGHT) == BiomeNeighbor.RIGHT)
						for each (neigbor in getCollision(_location.getRightPoint(), near))
							neigbor._activateNeighborsDelayer(hash, closed, phase, level, data, this, filter, delay);
					if ((hash & BiomeNeighbor.BOTTOM) == BiomeNeighbor.BOTTOM)
						for each (neigbor in getCollision(_location.getBottomPoint(), near))
							neigbor._activateNeighborsDelayer(hash, closed, phase, level, data, this, filter, delay);
					if ((hash & BiomeNeighbor.LEFT) == BiomeNeighbor.LEFT)
						for each (neigbor in getCollision(_location.getLeftPoint(), near))
							neigbor._activateNeighborsDelayer(hash, closed, phase, level, data, this, filter, delay);
					if ((hash & BiomeNeighbor.TOP) == BiomeNeighbor.TOP)
						for each (neigbor in getCollision(_location.getTopPoint(), near))
							neigbor._activateNeighborsDelayer(hash, closed, phase, level, data, this, filter, delay);
					if ((hash & BiomeNeighbor.BACK) == BiomeNeighbor.BACK)
						for each (neigbor in getCollision(_location.getBackPoint(), near))
							neigbor._activateNeighborsDelayer(hash, closed, phase, level, data, this, filter, delay);
					if ((hash & BiomeNeighbor.FRONT) == BiomeNeighbor.FRONT)
						for each (neigbor in getCollision(_location.getFrontPoint(), near))
							neigbor._activateNeighborsDelayer(hash, closed, phase, level, data, this, filter, delay);
				}
			}
		}
		
		
		/**
		 * Creates a new BiomeMatter instance
		 * BiomeMatter allow data representation and ocuppation on a Biome space
		 * @param	name
		 * @param	bounds
		 * @param	location
		 */
		public function BiomeMatter(name:String, allocation:BiomeAllocation = null, location:BiomeFlexPoint = null, content:* = null) {
			_allocation = (allocation || new BiomeAllocation()).getUnique(this);
			_location = location || new BiomeFlexPoint(0, 0, 0);
			_name = name || "MATTER_" + MATTER_COUNT;
			_behaviours = new MatterBehaviours(this);
			_content = content;
			_depthInfo = new DepthInfo(this);
			++MATTER_COUNT;
		}
		
		
		/**
		 * Current Biome
		 */
		public function get parent():Biome {
			return _parent;
		}
		
		
		public function set parent(value:Biome):void {
			if (_parent) {
				if (_parent !== value) {
					_parent.removeMatter(this);
				}
			}
			_parent = value;
		}
		
		
		/**
		 * Unique matter name in biome
		 */
		public function get name():String {
			return _name;
		}
		
		
		/**
		 * Allocation bounds on Biome
		 */
		public function get allocation():BiomeAllocation {
			return _allocation;
		}
		
		
		/**
		 * Current Matter location on Biome
		 * Need call matter.post() after location change
		 */
		public function get location():BiomeFlexPoint {
			return _location;
		}
		
		
		/**
		 * Cancel location and bounds changes
		 */
		public function revert():void {
		
		}
		
		
		/**
		 * Mark the matter to be updated on next tick
		 */
		public function post():void {
			if (_parent) {
				_tile = null;
				_parent.postMatter(this);
			}
		}
		
		
		/**
		 * Location entry
		 */
		public function get tile():BiomeEntry {
			if (_parent) {
				return _tile ||= _parent.getTileIn(_location);
			} else {
				return null;
			}
		}
		
		
		/**
		 * Render depth
		 */
		public function get depth():uint {
			return _depthInfo.current;
		}
		
		
		/**
		 * Displayable object
		 * Can be any value
		 */
		public function get content():DisplayObject {
			return _content;
		}
		
		
		public function set content(value:DisplayObject):void {
			_content = value;
		}
		
		
		/**
		 * Internal object behaviours
		 */
		public function get behaviours():MatterBehaviours {
			return _behaviours;
		}
		
		
		/**
		 * Depth info for sorting
		 */
		public function get depthInfo():DepthInfo {
			return _depthInfo;
		}
		
		
		
		
		/**
		 * Activation Update queue
		 */
		public function hasPendingActivation():Boolean {
			return _delayedCall > 0;
		}
		
		
		/**
		 * Cancel any pending update call
		 */
		public function cancelPendingActivation():void {
			clearInterval(_delayedCall);
			_delayedCall = 0;
		}
		
		
		/**
		 * @param nearLocation
		 * Search on a Biome ocuppation based on current matter location, even if not updated
		 * @return
		 */
		public function getCollision(nearLocation:BiomePoint = null, optbounds:BiomeBounds = null, filter:Function = null):Vector.<BiomeMatter> {
			var matter:BiomeMatter;
			var search:Vector.<BiomeMatter>;
			var point:BiomePoint;
			var ref:BiomeMatter = this;
			nearLocation = nearLocation || _location;
			optbounds = optbounds || _allocation.current;
			if (_parent) {
				search = _parent.getOccupation(nearLocation, optbounds, 0, this, filter);
			} else {
				search = new Vector.<BiomeMatter>();
			}
			return search;
		}
		
		
		/**
		 *
		 * @param	nextLocation
		 * @return
		 */
		public function isOutOfBounds(nearLocation:BiomePoint, optbounds:BiomeBounds = null):Boolean {
			var result:Boolean;
			optbounds = optbounds || _allocation.current;
			optbounds.iterate(function(point:BiomePoint):void {
					if (!_parent.getTileIn(nearLocation.offset(point))) {
						result = true;
						optbounds.prevent();
					}
				});
			return result;
		}
		
		
		/* INTERFACE gate.sirius.isometric.recycler.IRecyclable */ /**
		 *
		 */
		public function recyclerDump():void {
		
		}
		
		
		/**
		 *
		 * @param	...args
		 */
		public function recyclerCollect(... args:Array):void {
			//_name = name;
			//name:String, allocation:BiomeAllocation = null, location:BiomeFlexPoint = null, content:* = null
		}
		
		
		/**
		 * Destroy the instance and free memory
		 * @param	recycle		If true, the matter will be sent to recycler for post usage
		 */
		public function dispose(recycle:Boolean):void {
			if (recycle) {
				Recycler.GATE.dump(this as IRecyclable);
				if (_parent) {
					parent = null;
				}
			} else {
				_depthInfo.dispose();
				_parent = null;
				_allocation = null;
				_location = null;
				_content = null;
				_depthInfo = null;
				_behaviours = null;
			}
		}
		
		
		/**
		 *
		 * @param	options
		 * @param	mirror
		 * @return
		 */
		public function clone(options:uint = 0, mirror:Boolean = false):BiomeMatter {
			var matter:BiomeMatter = new BiomeMatter(_name + "_copy", null, _location.clone(), _content);
			matter._allocation = _allocation.clone(matter, options, mirror);
			matter._behaviours = _behaviours.clone() as MatterBehaviours;
			return matter;
		}
		
		
		/**
		 * Blank method for implementation
		 */
		public function activate(phase:uint, from:BiomeMatter, data:*):void {
		}
		
		
		/**
		 * Remove matter from current Biome
		 */
		public function removeFromBiome():void {
			if (_parent) {
				_parent.removeMatter(this);
			}
		}
		
		
		/**
		 * Request update to all conected neighbors
		 * @param	hash
		 * @param	phase
		 */
		public function activateNeighbors(hash:uint, phase:uint, filter:Function, level:uint = 1, data:* = null, delay:uint = 0, bounds:BiomeBounds = null):void {
			var closed:Vector.<BiomeMatter> = new Vector.<BiomeMatter>();
			if (level == 0)
				level = 99999;
			_activateNeighbors(hash, closed, phase, level, data, this, filter, delay, bounds);
		}
		
		
		public function toString():String {
			return "[BiomeMatter interaction=" + interaction + " name=" + name + " allocation=" + allocation + " location=" + location + " tile=" + tile + " content=" + content + " behaviours=" + behaviours + "]";
		}
	
	
	}

}