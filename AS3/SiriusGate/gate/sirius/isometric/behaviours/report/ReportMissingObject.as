package gate.sirius.isometric.behaviours.report {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ReportMissingObject {
		
		private var _type:String;
		
		private var _id:String;
		
		public function ReportMissingObject(type:String, id:String) {
			_type = type;
			_id = id;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function toString():String {
			return "[ Report {missing:" + _type + ", id:" + _id + " } ]";
		}
	
	}

}