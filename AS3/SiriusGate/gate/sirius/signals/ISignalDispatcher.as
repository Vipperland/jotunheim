package gate.sirius.signals {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface ISignalDispatcher {
		
		/**
		 * Signal Owner
		 */
		function get author():Object;
		
		/**
		 * Hold a listener
		 * @param	handler
		 */
		function hold(handler:Function):void;
		
		/**
		 *
		 * @param	...rest
		 */
		function push(... rest:Array):void;
		
		/**
		 * Release a listener
		 * @param	type
		 * @param	name
		 * @param	handler
		 * @param	all
		 * @return
		 */
		function release(handler:Function):void;
		
		/**
		 * Send a Signal
		 * @param	Type
		 * @param	name
		 * @param	recyclable
		 * @param	... props
		 */
		function send(Type:Class, recyclable:Boolean = true, ... props:Array):void;
		
		/**
		 * Remove all Signals
		 */
		function reset():void;
		
		/**
		 * Send signal to Recycler
		 */
		function dispose():void;
	
	}

}