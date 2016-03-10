package gate.sirius.isometric.signal {
	import flash.display.Sprite;
	import gate.sirius.isometric.view.SpriteSheet;
	import gate.sirius.isometric.view.SpriteSheetAnimation;
	import gate.sirius.signals.Signal;
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class SpriteSheetSignal extends Signal {
		
		private var _phase:uint;
		
		private function _constructor(phase:uint):void {
			_phase = phase;
		}
		
		
		public function SpriteSheetSignal(author:Sprite) {
			super(_constructor);
		}
		
		
		public function get sprite():SpriteSheet {
			return dispatcher.author as SpriteSheet;
		}
		
		public function started():Boolean {
			return _phase == 0;
		}
		
		public function finished():Boolean {
			return _phase == 1;
		}
		
	}

}