package gate.sirius.modloader.signals {
	import gate.sirius.file.IFileInfo;
	import gate.sirius.modloader.ModLoader;
	import gate.sirius.signals.Signal;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ResourceSignal extends Signal {
		
		private var _file:IFileInfo;
		private var _progress:Number;
		
		public function ResourceSignal() {
			super(_constructor);
		}
		
		
		private function _constructor(file:IFileInfo = null, progress:Number = 0):void {
			_file = file;
			_progress = progress;
		}
		
		
		public function get resouces():ModLoader {
			return dispatcher.author as ModLoader;
		}
		
		
		public function get progress():Number {
			return _progress;
		}
		
		public function get file():IFileInfo {
			return _file;
		}
		
		
		override public function dispose(recyclable:Boolean):void {
			_file = null;
			super.dispose(recyclable);
		}
		
	}

}