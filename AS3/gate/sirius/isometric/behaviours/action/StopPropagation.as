package gate.sirius.isometric.behaviours.action {
	import gate.sirius.isometric.behaviours.report.Report;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class StopPropagation extends BasicAction {
		
		public function StopPropagation(id:String = null) {
			super(id);
		}
		
		override public function procced(report:Report):void {
			report.stopPropagation();
		}
	
	}

}