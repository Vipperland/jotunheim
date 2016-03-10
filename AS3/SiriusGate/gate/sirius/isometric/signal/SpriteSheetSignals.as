package gate.sirius.isometric.signal {
	
	import gate.sirius.isometric.view.SpriteSheet;
	import gate.sirius.isometric.view.SpriteSheetAnimation;
	import gate.sirius.signals.SignalDispatcher;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class SpriteSheetSignals {
		
		private var _start:SignalDispatcher;
		
		private var _complete:SignalDispatcher;
		
		
		public function SpriteSheetSignals(sprite:SpriteSheet) {
			_start = new SignalDispatcher(sprite);
			_complete = new SignalDispatcher(sprite);
		}
		
		
		public function get start():SignalDispatcher {
			return _start;
		}
		
		
		public function get complete():SignalDispatcher {
			return _complete;
		}
	
	}

}