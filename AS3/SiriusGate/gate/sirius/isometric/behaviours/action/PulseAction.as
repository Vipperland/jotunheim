package gate.sirius.isometric.behaviours.action {
	import gate.sirius.isometric.behaviours.report.Report;
	import gate.sirius.isometric.behaviours.verifiers.Verifiers;
	import gate.sirius.isometric.timer.BiomeHeart;
	import gate.sirius.isometric.timer.IHeartbeat;
	import gate.sirius.timer.IActiveController;
	import gate.sirius.timer.IActiveObject;
	/**
	 * ...
	 * @author Rim Project
	 */
	public class PulseAction extends ChainedAction implements IHeartbeat {
		
		internal var _report_self:Report;
		
		internal var _ups:int;
		
		internal var _alive:Boolean;
		
		
		/**
		 * If 1
		 * 	Will trigger execute() until verifiers checked as FALSE
		 * If -1
		 * 	Will trigger execute() until verifiers checked as TRUE
		 */
		public function mode:int;
		
		public function PulseAction(id:String = null) {
			super(id);
			mode = 1;
			_ups = 1;
			_condition = new Verifiers();
		}
		
		/**
		 * Execute Avoid actions chain. If mode is greater than 0, the action will connect to BiomeHeart until Procced chain
		 * @param	report
		 */
		override public function avoid(report:Report):void {
			if (mode > 0){
				if (_report_self == null){
					_report_self = report.getBlueprint();
					BiomeHeart.ME.connect(this);
				}
			}else{
				BiomeHeart.ME.disconnect(this);
				super.avoid(_report_self || report);
				_report_self = null;
			}
			
		}
		
		override public function procced(report:Report):void {
			if (mode < 0){
				if (_report_self == null){
					_report_self = report.getBlueprint();
					BiomeHeart.ME.connect(this);
				}
			}else{
				BiomeHeart.ME.disconnect(this);
				super.procced(_report_self || report);
				_report_self = null;
			}
		}
		
		
		/* INTERFACE gate.sirius.isometric.timer.IHeartbeat */
		
		public function get ups():uint {
			return _ups;
		}
		
		public function pulse(time:Number):void {
			if (_report_self != null){
				execute(_report_self);
			}
		}
		
	}

}