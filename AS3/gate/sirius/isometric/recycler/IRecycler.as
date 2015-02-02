package gate.sirius.isometric.recycler {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface IRecycler {
		
		/**
		 * Add an inactivated object to queue
		 * @param	object
		 */
		function dump (object:IRecyclable) : void;
		
		/**
		 * Collect an inactivated objeto from queue and return a ticket
		 * @param	Type
		 * @param	...props
		 * @return
		 */
		function collect (Type:Class, ...props:Array) : IRecycledObject;
		
		/**
		 *  Clear all queues
		 */
		function clearTrash () : void;
		
		/**
		 * Clear all objects from a queue
		 * @param	Type
		 */
		function discartAllOf (Type:Class) : void;
		
		/**
		 * Length of a queue by object type
		 * @param	Type
		 * @return
		 */
		function lengthOf (Type:Class) : int;
		
		/**
		 * Calls a method for each object in a specified queue
		 * @param	handler
		 * @param	discart
		 * @param	...types
		 */
		function filter (handler:Function, discart:Boolean, ...types:Array) : void;
		
		/**
		 * 
		 * @return
		 */
		function toString () : String;
		
	}
	
}