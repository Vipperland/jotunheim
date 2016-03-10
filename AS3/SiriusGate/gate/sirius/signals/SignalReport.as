package gate.sirius.signals {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SignalReport {
		
		static public const GATE:SignalReport = new SignalReport(Key);
		
		private var _listeners:Vector.<Function>;
		
		public var enabled:Boolean;
		
		public function SignalReport(key:Class) {
			if (key !== Key) {
				throw new Error("Can't create SignalReport instance. Use SignalReport.GATE instead of new SignalReport()");
			}
			_reset();
		}
		
		private function _reset():void {
			_listeners = new Vector.<Function>();
		}
		
		public function hold(handler:Function):void {
			if (_listeners.indexOf(handler) == -1) {
				_listeners[_listeners.length] = handler;
			}
		}
		
		public function release(handler:Function):void {
			var iof:int = _listeners.indexOf(handler);
			if (iof !== -1) {
				_listeners.splice(iof, 1);
			}
		}
		
		internal function _send(ticket:SignalTicket):void {
			if (enabled) {
				for each (var f:Function in _listeners) {
					f(ticket);
				}
			}
		}
	
	}

}

class Key {
	public function Key() {
	
	}
}