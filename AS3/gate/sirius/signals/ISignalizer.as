package gate.sirius.signals 
{
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface ISignalizer 
	{
		
		function get author () : Object;
		
		/**
		 * Hold a listener
		 * @param	name
		 * @param	handler
		 */
		function hold (name:String, handler:Function) : void;
		
		function push (...rest:Array) : void;
		
		/**
		 * Release a listener
		 * @param	name
		 * @param	handler
		 */
		function release (name:String, handler:Function) : void;
		
		/**
		 * Send a Signal
		 * @param	signal
		 */
		function send (signal:Signal) : void;
		
		/**
		 * Remove all Signals
		 */
		function reset () : void;
		
		function dispose () : void;
		
	}

}