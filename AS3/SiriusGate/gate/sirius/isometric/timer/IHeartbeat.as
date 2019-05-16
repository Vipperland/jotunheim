package gate.sirius.isometric.timer {
	
	/**
	 * ...
	 * @author Rim Project
	 */
	public interface IHeartbeat {
		
		function get ups():uint;
		
		function pulse(time:Number):void;
		
	}
	
}