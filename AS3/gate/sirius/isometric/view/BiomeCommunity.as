package gate.sirius.isometric.view {
	import flash.utils.Dictionary;
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.layout.IBiomeLayout;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.scenes.BiomeRoom;
	import gate.sirius.isometric.signal.BiomeRoomSignal;
	
	
	/**
	 * ...
	 * @author asdasd
	 */
	public class BiomeCommunity {
		
		/** @private */
		private var _biome:Biome;
		
		/** @private */
		private var _ploting:Dictionary;
		
		/** @private */
		private var _visibleRooms:Vector.<BiomeRoom>;
		
		
		public function BiomeCommunity(biome:Biome) {
			_biome = biome;
			_ploting = new Dictionary(true);
			_visibleRooms = new Vector.<BiomeRoom>();
		}
		
		
		/**
		 * Get aq registered room
		 * @param	roomId
		 * @return
		 */
		public function getRoom(roomId:String):BiomeRoom {
			return _ploting[roomId] as BiomeRoom;
		}
		
		
		/**
		 * Add a room data into biome (hide state)
		 * @param	room
		 * @return
		 */
		public function addRoom(room:BiomeRoom, show:Boolean = false):BiomeRoom {
			_ploting[room.id] = room;
			for each (var matter:BiomeMatter in room.objects) {
				_biome.addMatter(matter);
			}
			if (show) {
				showRoom(room.id);
			}
			return room;
		}
		
		
		/**
		 * Clear all room reference from Biome
		 * @param	id
		 * @return
		 */
		public function removeRoom(id:String):BiomeRoom {
			var room:BiomeRoom = getRoom(id);
			if (room) {
				for each (var matter:BiomeMatter in room.objects) {
					_biome.removeMatter(matter);
				}
				hideRoom(id);
				delete _ploting[id];
			}
			return room;
		}
		
		
		/**
		 * Show room objects and tiles
		 * @param	id
		 * @return
		 */
		public function showRoom(id:String):BiomeRoom {
			var room:BiomeRoom = getRoom(id);
			if (room && _visibleRooms.indexOf(room) == -1) {
				_visibleRooms[_visibleRooms.length] = room;
				_biome.viewport.showArea(room.location, room.bounds, 0, true);
				_biome.signals.ENTER_ROOM.send(BiomeRoomSignal, true, room);
				room.behaviours.enter.execute(null, _biome.getTileIn(room.location), room, null);
			}
			return room;
		}
		
		
		/**
		 * Hide all room objects and tiles from grid
		 * @param	id
		 * @return
		 */
		public function hideRoom(id:String):BiomeRoom {
			var room:BiomeRoom = getRoom(id);
			if (room) {
				var iof:int = _visibleRooms.indexOf(room);
				if (iof !== -1) {
					_visibleRooms.splice(iof, 1);
					_biome.viewport.hideArea(room.location, room.bounds, 0);
					_biome.signals.LEAVE_ROOM.send(BiomeRoomSignal, true, room);
					room.behaviours.leave.execute(null, _biome.getTileIn(room.location), room, null);
				}
			}
			return room;
		}
		
		
		/**
		 * Hide all visible rooms
		 */
		public function hideAllRooms(... exceptions:Array):void {
			for each (var room:BiomeRoom in _visibleRooms) {
				if (exceptions.indexOf(room.id) == -1) {
					hideRoom(room.id);
				}
			}
		}
		
		
		/**
		 * Sort room matter
		 * @param	layout
		 * @param	sortMode
		 * @return
		 */
		public function sortRoomMatter(roomId:String, layout:IBiomeLayout):Vector.<BiomeMatter> {
			var room:BiomeRoom = getRoom(roomId);
			return room ? layout.sort(room.objects) : null;
		}
		
		
		/**
		 * Current Rooms mounted in Biome
		 */
		public function get visibleRooms():Vector.<BiomeRoom> {
			return _visibleRooms;
		}
	
	
	}

}