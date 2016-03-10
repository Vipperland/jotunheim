package gate.sirius.file.signals {
	import gate.sirius.file.IFileInfo;
	import gate.sirius.file.ISequentialLoader;
	import gate.sirius.signals.Signal;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class LoaderSignal extends Signal {
		
		static public const START:String = "start";
		
		static public const ERROR:String = "error";
		
		static public const PROGRESS:String = "progress";
		
		static public const FILE_LOADED:String = "fileLoaded";
		
		static public const COMPLETE:String = "complete";
		
		private var _type:String;
		
		public function LoaderSignal() {
			super(_construct);
		}
		
		protected function _construct(... args:Array):void {
			_type = args.pop();
		}
		
		public function get loader():ISequentialLoader {
			return dispatcher ? dispatcher.author as ISequentialLoader : null;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function get file():IFileInfo {
			return loader.currentFile;
		}
	
	}

}