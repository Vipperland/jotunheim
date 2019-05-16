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
		
		public function ResourceSignal() {
			super(_constructor);
		}
		
		
		private function _constructor(file:IFileInfo = null):void {
			_file = file;
		}
		
		
		public function get resouces():ModLoader {
			return dispatcher.author as ModLoader;
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