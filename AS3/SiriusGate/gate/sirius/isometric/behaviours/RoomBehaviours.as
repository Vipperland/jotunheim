package gate.sirius.isometric.behaviours {
	import gate.sirius.isometric.behaviours.action.Actions;
	import gate.sirius.isometric.data.BiomeEntry;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.scenes.BiomeRoom;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class RoomBehaviours extends Behaviours {
		
		private var _added:Actions;
		
		private var _removed:Actions;
		
		private var _enter:Actions;
		
		private var _leave:Actions;
		
		private var _move:Actions;
		
		private var _interact:Actions;
		
		
		public function RoomBehaviours(origin:BiomeRoom) {
			_added = new Actions();
			_removed = new Actions();
			_enter = new Actions();
			_leave = new Actions();
			_move = new Actions();
			_interact = new Actions();
			setOrigin(origin);
		}
		
		
		public function onMatterAdded(matter:BiomeMatter):void {
			_added.execute(room, null, null, matter);
		}
		
		
		public function onMatterRemoved(matter:BiomeMatter):void {
			matter.behaviours.onRemoved(room);
		}
		
		
		public function onEnterRoom(location:BiomeEntry, matter:BiomeMatter):void {
			_enter.execute(room, location, room, matter);
		}
		
		
		public function onLeaveRoom(location:BiomeEntry, matter:BiomeMatter):void {
			_leave.execute(room, location, room, matter);
		}
		
		
		public function onObjectMove(matter:BiomeMatter):void {
			_move.execute(room, matter.tile, room, matter);
		}
		
		
		public function onObjectInteraction(from:BiomeMatter, matter:BiomeMatter):void {
			_interact.execute(room, matter.tile, room, matter);
		}
		
		
		public function dispose():void {
			setOrigin(null);
			_added = null;
			_removed = null;
			_enter = null;
			_leave = null;
			_move = null;
			_interact = null;
		}
		
		
		public function get added():Actions {
			return _added;
		}
		
		
		public function get removed():Actions {
			return _removed;
		}
		
		
		public function get enter():Actions {
			return _enter;
		}
		
		
		public function get leave():Actions {
			return _leave;
		}
		
		
		public function get move():Actions {
			return _move;
		}
		
		
		public function get interact():Actions {
			return _interact;
		}
		
		
		public function get room():BiomeRoom {
			return _targetOrigin as BiomeRoom;
		}
	
	
	}

}