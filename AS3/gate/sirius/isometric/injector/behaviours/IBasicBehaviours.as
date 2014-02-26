package gate.sirius.isometric.injector.behaviours {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public interface IBasicBehaviours {
		
		function get approach():IBehaviour;
		function set approach(value:IBehaviour):void;
		
		function get deviate():IBehaviour;
		function set deviate(value:IBehaviour):void;
		
		function get enter():IBehaviour;
		function set enter(value:IBehaviour):void;
		
		function get leave():IBehaviour;
		function set leave(value:IBehaviour):void;
	
	}

}