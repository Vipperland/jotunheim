package gate.sirius.isometric.recycler {
	import gate.sirius.isometric.matter.BiomeMatter;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface IRecycledObject {
		
		/**
		 * Merge properties into recycled object
		 * @param	... properties
		 * @return
		 */
		function flush (...properties:Array) : *;

		/**
		 * Call object function width custom arguments
		 * @param	method
		 * @param	... args
		 * @return
		 */
		function call(method:String, ... args:Array) : IRecycledObject;

		/**
		 * Call object function width custom arguments
		 * @param	method
		 * @param	args
		 * @return
		 */
		function call2 (method:String, args:Array) : IRecycledObject;
		
		/**
		 * One time only access to recycled object
		 */
		function get content():*;
	}
	
}