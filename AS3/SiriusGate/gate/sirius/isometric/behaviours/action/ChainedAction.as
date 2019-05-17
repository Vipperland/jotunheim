package gate.sirius.isometric.behaviours.action {
	import gate.sirius.isometric.behaviours.report.Report;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ChainedAction extends BasicAction {
		
		private var _success:Actions;
		
		private var _fail:Actions;
		
		/**
		 * 
		 * @param	id
		 */
		public function ChainedAction(id:String = null) {
			super(id);
			_success = new Actions();
			_fail = new Actions();
		}
		
		override public function avoid(report:Report):void {
			_fail.execute(report);
		}
		
		override public function procced(report:Report):void {
			_success.execute(report);
		}
		
		public function get success():Actions {
			return _success;
		}
		
		public function get fail():Actions {
			return _fail;
		}
	
	}

}