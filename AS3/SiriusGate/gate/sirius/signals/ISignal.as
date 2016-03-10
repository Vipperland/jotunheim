package gate.sirius.signals {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface ISignal {
		
		/**
		 * The current dispatcher
		 */
		function get dispatcher():SignalDispatcher;
		
		/**
		 * Current propagation count
		 */
		function get callCount():uint;
		
		/**
		 * Destroy or send instance to Recycler
		 * @param	recyclable
		 */
		function dispose(recyclable:Boolean):void;
		
		/**
		 * Interrupts the signal propagation
		 */
		function stopPropagation():void;
	
	}

}