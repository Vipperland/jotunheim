package gate.sirius.log.signals {
	import gate.sirius.signals.Signal;
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class ULogSignal extends Signal {
		
		private var _level:uint;
		
		private var _message:String;
		
		public function ULogSignal() {
			super(_constructor);
		}
		
		private function _constructor(level:uint, message:String):void {
			_message = message;
			_level = level;
			
		}
		
		public function get level():uint {
			return _level;
		}
		
		public function get message():String {
			return _message;
		}
		
	}

}