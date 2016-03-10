package gate.sirius.modloader.signals {
	import gate.sirius.signals.SignalDispatcher;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ResourceSignals {
		
		private var _complete:SignalDispatcher;
		
		private var _error:SignalDispatcher;
		
		private var _on_file:SignalDispatcher;
		
		
		public function ResourceSignals(author:Object) {
			_complete = new SignalDispatcher(author);
			_error = new SignalDispatcher(author);
			_on_file = new SignalDispatcher(author);
		}
		
		
		public function get COMPLETE():SignalDispatcher {
			return _complete;
		}
		
		
		public function get ERROR():SignalDispatcher {
			return _error;
		}
		
		
		public function get ON_FILE():SignalDispatcher {
			return _on_file;
		}
	
	}

}