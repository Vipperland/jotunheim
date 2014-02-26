package gate.sirius.isometric.injector.log {
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Report implements IReport {
		
		private var _from:Object;
		private var _target:Object;
		
		private var _history:Array;
		
		public function Report(from:Object, target:Object) {
			_target = target;
			_from = from;
			_history = [];
		}
		
		public final function get from():Object {
			return _from;
		}
		
		public final function get target():Object {
			return _target;
		}
		
	}

}