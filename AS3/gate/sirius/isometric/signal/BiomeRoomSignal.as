package gate.sirius.isometric.signal {
	
	import gate.sirius.isometric.scenes.BiomeRoom;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeRoomSignal extends BiomeSignal {
		
		private var _room:BiomeRoom;
		
		private function _constructor(room:BiomeRoom):void {
			_room = room;
		}
		
		public function BiomeRoomSignal(contructor:Function = null) {
			super(_resolveHandler(contructor, _constructor));
		}
		
		override public function dispose(recyclable:Boolean):void {
			_room = null;
			super.dispose(recyclable);
		}
		
		public function get room():BiomeRoom {
			return _room;
		}
	
	}
}