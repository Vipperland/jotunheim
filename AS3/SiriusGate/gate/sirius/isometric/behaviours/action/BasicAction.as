package gate.sirius.isometric.behaviours.action {
	
	import flash.utils.getQualifiedClassName;
	import gate.sirius.isometric.behaviours.report.Report;
	import gate.sirius.isometric.behaviours.verifiers.Verifiers;
	import gate.sirius.isometric.behaviours.core.ICoreElement;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class BasicAction implements ICoreElement {
		
		private static var COUNT:uint = 0;
		
		private var _id:String;
		
		private var _verifiers:Verifiers;
		
		public function BasicAction(id:String = null) {
			_id = id || getQualifiedClassName(this).split("::").pop() + "#" + COUNT;
			_verifiers = new Verifiers();
			++COUNT;
		}
		
		
		internal final function execute(report:Report):void {
			if (_verifiers.check(report)) {
				procced(report);
			} else {
				avoid(report);
			}
		}
		
		
		public function avoid(report:Report):void {
		}
		
		
		public function procced(report:Report):void {
		}
		
		
		public function construct(...args:Array):void {
		
		}
		
		
		public function get id():String {
			return _id;
		}
		
		
		public function get verifiers():Verifiers {
			return _verifiers;
		}
		
		
		public function toString():String {
			return getQualifiedClassName(this) + "@" + _id + "\n" + _verifiers.toString();
		}
	
	}

}