package gate.sirius.isometric.tools {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class BiomeKeyboard {
		
		private static var _instance:BiomeKeyboard;
		
		
		static public function get instance():BiomeKeyboard {
			return _instance;
		}
		
		
		public function get keyCount():uint {
			return _keyCount;
		}
		
		
		static public function init(stage:Stage):void {
			_instance = new BiomeKeyboard(stage);
		}
		
		private var _stage:Stage;
		
		private var _keyCount:uint;
		
		private var _keyStates:Array;
		
		private var _trigger:Array;
		
		
		public function BiomeKeyboard(stage:Stage):void {
			if (_instance) {
				throw new Error("Can't create a new instance of BiomeKeyboard(), use BiomeKeyboard.instance instead of new", 10001);
			}
			_instance = this;
			_stage = stage;
			_keyStates = [];
			_trigger = [];
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, _switchKeyState);
			_stage.addEventListener(KeyboardEvent.KEY_UP, _switchKeyState);
		}
		
		
		private function _switchKeyState(e:KeyboardEvent):void {
			var activatedState:Boolean = e.type == KeyboardEvent.KEY_DOWN;
			_keyStates[e.keyCode] = activatedState;
			if (activatedState) {
				if (!_trigger[e.keyCode]) {
					_trigger[e.keyCode] = 2;
				}
			} else {
				_trigger[e.keyCode] = 0;
			}
			_keyCount += e.type == KeyboardEvent.KEY_DOWN ? 1 : -1;
		}
		
		
		public function isActivated(keyCode:uint):Boolean {
			return _keyStates[keyCode] == true;
		}
		
		
		public function getTrigger(keyCode:uint):Boolean {
			var isDown:Boolean = _keyStates[keyCode] == true;
			if (isDown) {
				if (_trigger[keyCode] == 2) {
					_trigger[keyCode] = 1;
					return true;
				}
			}
			return false;
		}
	
	}

}