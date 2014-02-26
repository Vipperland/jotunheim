package gate.sirius.timer {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface IActiveObject {
		
		function tick(time:Number):void;
		
		function onAdded():void;
		
		function onRemoved():void;
	
	}

}