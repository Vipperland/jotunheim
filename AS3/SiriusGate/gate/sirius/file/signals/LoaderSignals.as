package gate.sirius.file.signals {
	import gate.sirius.file.SequentialLoader;
	import gate.sirius.signals.ISignalDispatcher;
	import gate.sirius.signals.SignalDispatcher;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class LoaderSignals implements ILoaderSignals {
		
		private var _loadError:ISignalDispatcher;
		
		private var _loadComplete:ISignalDispatcher;
		
		private var _loadProgress:ISignalDispatcher;
		
		private var _fileLoaded:ISignalDispatcher;
		
		private var _loadStart:ISignalDispatcher;
		
		public function LoaderSignals(author:SequentialLoader) {
			_loadComplete = new SignalDispatcher(author);
			_loadError = new SignalDispatcher(author);
			_loadProgress = new SignalDispatcher(author);
			_fileLoaded = new SignalDispatcher(author);
			_loadStart = new SignalDispatcher(author);
		}
		
		public function dispose():void {
			_loadComplete.dispose();
			_loadError.dispose();
			_loadProgress.dispose();
			_fileLoaded.dispose();
			_loadStart.dispose();
		}
		
		public function get LOAD_ERROR():ISignalDispatcher {
			return _loadError;
		}
		
		public function get LOAD_COMPLETE():ISignalDispatcher {
			return _loadComplete;
		}
		
		public function get LOAD_PROGRESS():ISignalDispatcher {
			return _loadProgress;
		}
		
		public function get LOAD_START():ISignalDispatcher {
			return _loadStart;
		}
		
		public function get FILE_LOADED():ISignalDispatcher {
			return _fileLoaded;
		}
	
	}

}