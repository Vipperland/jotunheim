package gate.sirius.isometric.injector.behaviours {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BasicBehaviours implements IBasicBehaviours {
		
		private var _approach:IBehaviour;
		
		private var _deviate:IBehaviour;
		
		private var _enter:IBehaviour;
		
		private var _leave:IBehaviour;
		
		
		public function BasicBehaviours() {
		}
		
		public function get approach():IBehaviour {
			return _approach;
		}
		
		public function set approach(value:IBehaviour):void {
			_approach = value;
		}
		
		public function get deviate():IBehaviour {
			return _deviate;
		}
		
		public function set deviate(value:IBehaviour):void {
			_deviate = value;
		}
		
		public function get enter():IBehaviour {
			return _enter;
		}
		
		public function set enter(value:IBehaviour):void {
			_enter = value;
		}
		
		public function get leave():IBehaviour {
			return _leave;
		}
		
		public function set leave(value:IBehaviour):void {
			_leave = value;
		}
	
	}

}