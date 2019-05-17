package gate.sirius.isometric.behaviours.action {
	import gate.sirius.isometric.behaviours.report.Report;
	import gate.sirius.isometric.behaviours.verifiers.Verifiers;
	import gate.sirius.isometric.timer.BiomeHeart;
	import gate.sirius.isometric.timer.IHeartbeat;
	
	/**
	 * ...
	 * @author Rim Project
	 */
	public class PulseAction extends ChainedAction implements IHeartbeat {
		
		internal var _report_self:Report;
		
		internal var _ups:int;
		
		internal var _alive:Boolean;
		
		
		/**
		 * Determine the diretion os heartbeat
		 * If 1, will connect to the heart only if verifiers output false
		 * If -1, will connect to the heart only if verifiers output true
		 */
		public function mode:int;
		
		/**
		 * The PulseAction type will connect to the BiomeHeart and will run in a predetermined UPS
		 * @param	id
		 */
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
		
		/**
		 * Execute Procced actions chain. If mode is greater than 0, the action will connect to BiomeHeart until Avoid chain
		 * @param	report
		 */
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