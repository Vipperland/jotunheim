package gate.sirius.isometric.view {
	import gate.sirius.isometric.signal.SpriteSheetSignals;
	import gate.sirius.signals.SignalDispatcher;
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class SpriteSheetAnimation {
		
		private var _id:uint;
		
		private var _start:uint;
		
		private var _end:uint;
		
		private var _repeat:Boolean;
		
		public function SpriteSheetAnimation(id:uint, start:uint, end:uint, repeat:Boolean) {
			_repeat = repeat;
			_end = end;
			_start = start;
			_id = id;
			
		}
		
		public function get id():uint {
			return _id;
		}
		
		public function get start():uint {
			return _start;
		}
		
		public function get end():uint {
			return _end;
		}
		
		public function get repeat():Boolean {
			return _repeat;
		}
		
	}

}