package gate.sirius.isometric.injector.behaviours {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public interface IBehaviours extends IBasicBehaviours {
		
		function get interact():IBehaviour;
		function set interact(value:IBehaviour):void;
		
		function get push():IBehaviour;
		function set push(value:IBehaviour):void;
		
		function get pull():IBehaviour;
		function set pull(value:IBehaviour):void;
		
		function get observed():IBehaviour;
		function set observed(value:IBehaviour):void;
		
		function get sight():IBehaviour;
		function set sight(value:IBehaviour):void;
		
		function get affected():IBehaviour;
		function set affected(value:IBehaviour):void;
		
		function get targeted():IBehaviour;
		function set targeted(value:IBehaviour):void;
	
	}

}