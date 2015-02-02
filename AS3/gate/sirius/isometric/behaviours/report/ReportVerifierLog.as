package gate.sirius.isometric.behaviours.report {
	
	import flash.utils.getQualifiedClassName;
	import gate.sirius.isometric.behaviours.verifiers.BasicVerifier;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ReportVerifierLog {
		
		private var _verifier:BasicVerifier;
		
		private var _success:Boolean;
		
		private var _time:int;
		
		public function ReportVerifierLog(verifier:BasicVerifier, time:int) {
			_verifier = verifier;
			_time = time;
		}
		
		public function get verifier():BasicVerifier {
			return _verifier;
		}
		
		public function link(report:Report):Boolean {
			_success = _verifier.check(report);
			return _success;
		}
		
		public function get success():Boolean {
			return _success;
		}
		
		public function get time():int {
			return _time;
		}
		
		public function toString():String {
			return "[ Report {verifier:" + getQualifiedClassName(_verifier) + "@" + _verifier.id + ", time:" + _time + "ms } ]";
		}
	
	}

}