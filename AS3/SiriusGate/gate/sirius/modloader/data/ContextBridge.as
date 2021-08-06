package gate.sirius.modloader.data {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class ContextBridge {
		
		private var _Engine:Object;
		public function get Engine():Object {
			return _Engine;
		}
		
		public function get Signals():Object {
			return _Engine.signals;
		}
		
		public function get Viewport():Object {
			return _Engine.viewport;
		}
		
		public function ContextBridge(engine:Object){
			_Engine = engine;
		}
	}

}