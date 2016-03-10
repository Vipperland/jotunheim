package gate.sirius.serializer.signals {
	import gate.sirius.serializer.SruDecoder;
	import gate.sirius.signals.SignalDispatcher;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruSignals {
		
		private var _parse:SignalDispatcher;
		
		private var _cancel:SignalDispatcher;
		
		private var _error:SignalDispatcher;
		
		public function SruSignals(author:SruDecoder) {
			_parse = new SignalDispatcher(author);
			_error = new SignalDispatcher(author);
			_cancel = new SignalDispatcher(author);
		}
		
		public function get PARSED():SignalDispatcher {
			return _parse;
		}
		
		public function get ERROR():SignalDispatcher {
			return _error;
		}
		
		public function get CANCEL():SignalDispatcher {
			return _cancel;
		}
	
	}

}