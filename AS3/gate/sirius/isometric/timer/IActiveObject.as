package gate.sirius.isometric.timer {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public interface IActiveObject {
		
		function tick(timeMultiplier:Number):void;
		
		function inactivated():void;
		
		function activated():void;
	
	}

}