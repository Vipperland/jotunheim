package gate.sirius.file.zip.signals {
	import gate.sirius.file.zip.IZip;
	import gate.sirius.file.zip.IZipFile;
	import gate.sirius.signals.Signal;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class ZipSignal extends Signal {
		
		static public const FILE_LOADED:String = "fileLoaded";
		
		static public const ERROR:String = "error";
		
		static public const PROGRESS:String = "progress";
		
		static public const COMPLETE:String = "complete";
		
		private var _type:String;
		
		
		public function ZipSignal() {
			super(_constructor);
		}
		
		
		private function _constructor(type:String):void {
			_type = type;
		}
		
		
		public function get zip():IZip {
			return dispatcher ? dispatcher.author as IZip : null;
		}
		
		
		public function get file():IZipFile {
			return zip ? zip.currentFile : null;
		}
		
		
		public function get progress():Number {
			return zip ? zip.currentProgress : 0;
		}
	
	}

}