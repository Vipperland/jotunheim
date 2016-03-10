package gate.sirius.isometric.behaviours.core {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface ICoreElement {
		
		function get id():String;
		
		function construct(... args:Array):void;
	
	}

}