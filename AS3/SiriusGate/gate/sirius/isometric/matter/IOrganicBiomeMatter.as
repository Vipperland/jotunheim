package gate.sirius.isometric.matter {
	
	import gate.sirius.isometric.timer.IHeartbeat;
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public interface IOrganicBiomeMatter extends IBiomeMatter, IHeartbeat {
		
		/**
		 * Skips the Ticker phase
		 */
		function get idle () : Boolean;
		function set idle (value:Boolean) : void;

		/**
		 * Force matter update
		 */
		function forceUpdate () : void;
		
	}
	
}