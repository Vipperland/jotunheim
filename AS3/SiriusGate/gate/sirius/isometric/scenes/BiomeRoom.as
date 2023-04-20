package gate.sirius.isometric.scenes {
	
	import gate.sirius.isometric.behaviours.RoomBehaviours;
	import gate.sirius.isometric.math.BiomeBox;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.matter.BiomeMatter;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class BiomeRoom {
		
		/** @private */
		static private var ROOM_COUNT:uint = 0;
		
		/** @private */
		private var _map:Array;
		
		/** @private */
		private var _objects:Vector.<BiomeMatter>;
		
		/** @private */
		private var _location:BiomePoint;
		
		/** @private */
		private var _bounds:BiomeBox;
		
		/** @private */
		private var _id:String;
		
		/** @private */
		private var _behaviours:RoomBehaviours;
		
		/** @private */
		private var _data:Object;
		
		
		/**
		 *
		 * @param	id
		 * @param	location
		 * @param	bounds
		 */
		public function BiomeRoom(id:String, location:BiomePoint, bounds:BiomeBox) {
			_id = id || "Room:" + ROOM_COUNT;
			_behaviours = new RoomBehaviours(this);
			_objects = new Vector.<BiomeMatter>();
			_bounds = bounds;
			_map = [];
			_location = location;
			++ROOM_COUNT;
		
		}
		
		
		/**
		 * Add various objects to the room
		 * @param	... objects
		 */
		public function addObjects(objects:Vector.<BiomeMatter>, validate:Boolean, replace:Boolean = false):void {
			for each (var matter:BiomeMatter in objects) {
				addObject(matter, validate, replace);
			}
		}
		
		
		/**
		 * Register an object in room
		 * @param	matter
		 * @param	validate
		 * @return
		 */
		public function addObject(matter:BiomeMatter, validate:Boolean, replace:Boolean = false):Boolean {
			var p:BiomePoint;
			if (_objects.indexOf(matter) !== -1)
				return false;
			matter.location.join(_location);
			if (validate) {
				if (matter.location.x < left || matter.location.y < top || matter.location.z < front || matter.location.x > right || matter.location.y > bottom || matter.location.z > back) {
					return false;
				} else {
					for each (p in matter.allocation.current) {
						var z:Array = (_map[p.y] ||= [])[p.x] ||= [];
						if (z[p.z]) {
							if (replace) {
								var occup:BiomeMatter = z[p.z];
								if (occup) {
									clearLocation.apply(null, occup.allocation.current.points);
								}
								continue;
							} else {
								return false;
							}
						}
					}
				}
			}
			for each (p in matter.allocation.current.points) {
				((_map[p.y] ||= [])[p.x] ||= [])[p.z] = matter;
			}
			_objects[_objects.length] = matter;
			_behaviours.onMatterAdded(matter);
			return true;
		}
		
		
		/**
		 * Remove objects under location
		 * @param	...points
		 */
		public function clearLocation(... points:Array):void {
			for each (var p:BiomePoint in points) {
				delete((_map[p.y] ||= [])[p.x] ||= [])[p.z];
			}
		}
		
		
		/**
		 * Remove an object
		 * @param	matter
		 * @return
		 */
		public function removeObject(matter:BiomeMatter):Boolean {
			var iof:int = _objects.indexOf(matter, 0);
			if (iof !== -1) {
				_objects.splice(iof, 1);
				matter.location.unjoin(_location);
				_behaviours.onMatterRemoved(matter);
				return true;
			}
			return false;
		}
		
		
		/**
		 * Dispose validated objects reference
		 */
		public function validateObjects():void {
			_map = [];
		}
		
		
		/**
		 * Room spatial info
		 */
		public function get bounds():BiomeBox {
			return _bounds;
		}
		
		
		/**
		 * Current position of the room in Grid
		 */
		public function get location():BiomePoint {
			return _location;
		}
		
		
		/**
		 * Unique room identifier
		 */
		public function get id():String {
			return _id;
		}
		
		
		/**
		 * Left/Top Left Wall
		 */
		public function get left():int {
			return _location.x;
		}
		
		
		/**
		 * Right/Botton right Wall
		 */
		public function get right():int {
			return _location.x + _bounds.width;
		}
		
		
		/**
		 * top wall
		 */
		public function get top():int {
			return _location.y;
		}
		
		
		/**
		 * Bottom Wall
		 */
		public function get bottom():int {
			return _location.y + _bounds.height;
		}
		
		
		/**
		 * Roof
		 */
		public function get front():int {
			return _location.z;
		}
		
		
		/**
		 * Floor
		 */
		public function get back():int {
			return _location.z + bounds.depth;
		}
		
		
		/**
		 * Room Objects
		 */
		public function get objects():Vector.<BiomeMatter> {
			return _objects;
		}
		
		
		/**
		 * Core behaviours
		 */
		public function get behaviours():RoomBehaviours {
			return _behaviours;
		}
		
		
		/**
		 * Custom data
		 */
		public function get data():Object {
			return _data;
		}
		
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		
		public function toString():String {
			return "[BiomeRoom {id:" + _id + ", objects:" + _objects.length + ", size:" + (_bounds.width + "x" + _bounds.height + "x" + _bounds.depth) + ", location:" + _location.x + "," + _location.y + "," + _location.z + "}]";
		}
		
		
		public function dispose(recycle:Boolean):void {
			for each (var matter:BiomeMatter in _objects) {
				matter.dispose(recycle);
			}
			_map = null;
			_behaviours.dispose();
		}
		
		public function willCollide(position:BiomePoint, bounds:BiomeBox):Boolean {
			if ((left >= position.x && left <= position.x + bounds.width) || (right >= position.x && right <= position.x + bounds.width)){
				if ((top >= position.y && top <= position.y + bounds.height) || (bottom >= position.y && bottom <= position.y + bounds.height)){
					if ((back >= position.z && back <= position.z + bounds.depth) || (front >= position.z && front <= position.z + bounds.depth)){
						return true;
					}
				}
			}
			return false;
		}
		
	}

}