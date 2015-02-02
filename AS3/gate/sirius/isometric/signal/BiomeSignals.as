package gate.sirius.isometric.signal {
	import gate.sirius.isometric.Biome;
	import gate.sirius.signals.SignalDispatcher;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class BiomeSignals {
		
		private var _createTile:SignalDispatcher;
		
		private var _showTile:SignalDispatcher;
		
		private var _hideTile:SignalDispatcher;
		
		private var _neightborUpdate:SignalDispatcher;
		
		private var _neightborCascade:SignalDispatcher;
		
		private var _matterAdded:SignalDispatcher;
		
		private var _matterRemoved:SignalDispatcher;
		
		private var _tileSearch:SignalDispatcher;
		
		private var _colliderPath:SignalDispatcher;
		
		private var _colliderEnd:SignalDispatcher;
		
		private var _enterRoom:SignalDispatcher;
		
		private var _leaveRoom:SignalDispatcher;
		
		private var _interaction:SignalDispatcher;
		
		
		public function BiomeSignals(author:Biome) {
			_createTile = new SignalDispatcher(author);
			_showTile = new SignalDispatcher(author);
			_hideTile = new SignalDispatcher(author);
			_neightborUpdate = new SignalDispatcher(author);
			_neightborCascade = new SignalDispatcher(author);
			_matterAdded = new SignalDispatcher(author);
			_matterRemoved = new SignalDispatcher(author);
			_tileSearch = new SignalDispatcher(author);
			_colliderPath = new SignalDispatcher(author);
			_colliderEnd = new SignalDispatcher(author);
			_enterRoom = new SignalDispatcher(author);
			_leaveRoom = new SignalDispatcher(author);
			_interaction = new SignalDispatcher(author);
		}
		
		
		public function reset():void {
			_createTile.reset();
			_showTile.reset();
			_hideTile.reset();
			_neightborUpdate.reset();
			_neightborCascade.reset();
			_matterAdded.reset();
			_matterRemoved.reset();
			_tileSearch.reset();
			_colliderPath.reset();
			_colliderEnd.reset();
			_enterRoom.reset();
			_leaveRoom.reset();
			_interaction.reset();
		}
		
		
		public function get TILE_SHOW():SignalDispatcher {
			return _showTile;
		}
		
		
		public function get TILE_HIDE():SignalDispatcher {
			return _hideTile;
		}
		
		
		public function get TILE_CREATE():SignalDispatcher {
			return _createTile;
		}
		
		
		//public static const NEIGHBOR:BiomeNeighborSignal;
		
		public function get NEIGHBOR_CASCADE():SignalDispatcher {
			return _neightborCascade;
		}
		
		
		public function get NEIGHBOR_UPDATE():SignalDispatcher {
			return _neightborUpdate;
		}
		
		
		public function get MATTER_ADDED():SignalDispatcher {
			return _matterAdded;
		}
		
		
		public function get MATTER_REMOVED():SignalDispatcher {
			return _matterRemoved;
		}
		
		
		public function get TILE_SEARCH():SignalDispatcher {
			return _tileSearch;
		}
		
		
		//public static const COLLIDER:BiomeColliderSignal;
		
		public function get COLLIDER_PATH():SignalDispatcher {
			return _colliderPath;
		}
		
		
		public function get COLLIDER_END():SignalDispatcher {
			return _colliderEnd;
		}
		
		
		//public static const ROOM:BiomeRoomSignal;
		
		public function get ENTER_ROOM():SignalDispatcher {
			return _enterRoom;
		}
		
		
		public function get LEAVE_ROOM():SignalDispatcher {
			return _leaveRoom;
		}
		
		
		//public static const INTERACTION:BiomeInteractionSignal;
		
		public function get INTERACTION():SignalDispatcher {
			return _interaction;
		}
	
	}

}