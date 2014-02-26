package gate.sirius.isometric.injector.behaviours {
	import gate.sirius.isometric.injector.AEVHook;
	import gate.sirius.isometric.injector.log.IReport;
	import gate.sirius.isometric.injector.log.Report;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Behaviour {
		
		static public function search(id:String):void {
			return COLLECTION[id];
		}
		
		private var _id:String;
		
		private var _owner:String;
		
		private var _target:Array;
		
		
		public function Behaviour(id:String, modid:String) {
			_id = id;
			_owner = modid;
			_target = new Array();
		}
		
		
		public function toString():String {
			return "Behaviour::" + _id + "#" + _owner;
		}
		
		
		public final function get id():String {
			return _id;
		}
		
		
		public final function get owner():String {
			return _owner;
		}
		
		
		public function get target():Array {
			return _target;
		}
		
		
		public final function execute(report:IReport):void {
			if (!report) {
				report = new Report(this, null);
			}
			for each (var actid:String in _target) {
				var act:Action = AEVHook.ACTIONS[actid];
				if (act) {
					act.execute(report);
					if (act.stopExecution()) {
						break;
					}
				}
			}
		}
	
	}

}