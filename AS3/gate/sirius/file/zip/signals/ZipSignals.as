package gate.sirius.file.zip.signals {
	
	import gate.sirius.file.zip.IZip;
	import gate.sirius.signals.ISignalDispatcher;
	import gate.sirius.signals.SignalDispatcher;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class ZipSignals {
		
		private var _file_loaded:ISignalDispatcher;
		
		private var _file_error:ISignalDispatcher;
		
		private var _progress:ISignalDispatcher;
		
		private var _complete:ISignalDispatcher;
		
		
		public function ZipSignals(author:IZip) {
			_file_loaded = new SignalDispatcher(author);
			_file_error = new SignalDispatcher(author);
			_progress = new SignalDispatcher(author);
			_complete = new SignalDispatcher(author);
		}
		
		
		public function get FILE_LOADED():ISignalDispatcher {
			return _file_loaded;
		}
		
		
		public function get FILE_ERROR():ISignalDispatcher {
			return _file_error;
		}
		
		
		public function get PROGRESS():ISignalDispatcher {
			return _progress;
		}
		
		public function get COMPLETE():ISignalDispatcher {
			return _complete;
		}
		
		
		public function dispose():void {
			_file_loaded.dispose();
			_file_error.dispose();
			_progress.dispose();
			_complete.dispose();
		}
	
	}

}