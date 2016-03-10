package gate.sirius.isometric.matter {
	
	import gate.sirius.timer.IActiveController;
	import gate.sirius.timer.IActiveObject;
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public interface IOrganicBiomeMatter extends IBiomeMatter, IActiveObject {
		
		/**
		 * Skips the Ticker phase
		 */
		function get idle () : Boolean;
		function set idle (value:Boolean) : void;

		/**
		 * Target FPS for Ticker
		 */
		function get fps () : uint;
		function set fps (value:uint) : void;

		/**
		 * Force matter update
		 */
		function forceUpdate () : void;
		
	}
	
}