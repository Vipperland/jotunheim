package gate.sirius.isometric.behaviours.report {
	
	import flash.utils.getQualifiedClassName;
	import gate.sirius.isometric.behaviours.action.BasicAction;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ReportActionLog {
		
		private var _action:BasicAction;
		
		private var _time:int;
		
		public function ReportActionLog(action:BasicAction, time:int) {
			_action = action;
			_time = time;
		}
		
		public function get action():BasicAction {
			return _action;
		}
		
		public function get time():int {
			return _time;
		}
		
		public function toString():String {
			return "[ Report {action:" + getQualifiedClassName(_action) + "@" + _action.id + ", time:" + _time + "ms} ]";
		}
	
	}

}