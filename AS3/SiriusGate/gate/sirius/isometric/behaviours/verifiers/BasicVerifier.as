package gate.sirius.isometric.behaviours.verifiers {
	import flash.utils.getQualifiedClassName;
	import gate.sirius.isometric.behaviours.action.Actions;
	import gate.sirius.isometric.behaviours.core.ICoreElement;
	import gate.sirius.isometric.behaviours.report.Report;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class BasicVerifier implements ICoreElement {
		
		private static var COUNT:uint = 0;
		
		private var _id:String;
		
		private var _success:Actions;
		
		private var _fail:Actions;
		
		public function BasicVerifier(id:String = null) {
			_id = id || "Verifier:" + COUNT;
			++COUNT;
			_success = new Actions();
			_fail = new Actions();
		}
		
		public function get id():String {
			return _id;
		}
		
		public function get success():Actions {
			return _success;
		}
		
		public function get fail():Actions {
			return _fail;
		}
		
		public function toString():String {
			return getQualifiedClassName(this) + _id;
		}
		
		public function check(report:Report):Boolean {
			return true;
		}
		
		public function resolve(report:Report, result:Boolean):void {
			if (result) {
				success.execute(report);
			} else {
				fail.execute(report);
			}
		}
		
		public function construct(... args:Array):void {
		
		}
	
	}

}