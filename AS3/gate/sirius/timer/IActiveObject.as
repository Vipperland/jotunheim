package gate.sirius.timer {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface IActiveObject {
		
		/**
		 * On Ticker call
		 * @param	time Time advanced
		 */
		function tick(time:Number):void;
		
		/**
		 * On added to ActiveController
		 * @param	ticker
		 */
		function onActivate(ticker:IActiveController):void;
		
		/**
		 * On removed from controller
		 * @param	ticker
		 */
		function onDeactivate(ticker:IActiveController):void;
	
	}

}