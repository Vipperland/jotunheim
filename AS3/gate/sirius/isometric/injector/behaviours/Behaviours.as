package gate.sirius.isometric.injector.behaviours {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Behaviours extends BasicBehaviours implements IBehaviours {
		
		private var _interact:IBehaviour;
		
		private var _push:IBehaviour;
		
		private var _pull:IBehaviour;
		
		private var _observed:IBehaviour;
		
		private var _sight:IBehaviour;
		
		private var _affected:IBehaviour;
		
		private var _targeted:IBehaviour;
		
		
		public function Behaviours() {
		
		}
		
		
		public function get interact():IBehaviour {
			return _interact;
		}
		
		
		public function set interact(value:IBehaviour):void {
			_interact = value;
		}
		
		
		public function get push():IBehaviour {
			return _push;
		}
		
		
		public function set push(value:IBehaviour):void {
			_push = value;
		}
		
		
		public function get pull():IBehaviour {
			return _pull;
		}
		
		
		public function set pull(value:IBehaviour):void {
			_pull = value;
		}
		
		
		public function get observed():IBehaviour {
			return _observed;
		}
		
		
		public function set observed(value:IBehaviour):void {
			_observed = value;
		}
		
		
		public function get sight():IBehaviour {
			return _sight;
		}
		
		
		public function set sight(value:IBehaviour):void {
			_sight = value;
		}
		
		
		public function get affected():IBehaviour {
			return _affected;
		}
		
		
		public function set affected(value:IBehaviour):void {
			_affected = value;
		}
		
		
		public function get targeted():IBehaviour {
			return _targeted;
		}
		
		
		public function set targeted(value:IBehaviour):void {
			_targeted = value;
		}
	
	}

}