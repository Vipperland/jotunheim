package gate.sirius.isometric.recycler {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public interface IRecyclable {
		
		/**
		 * On Added to Recycler
		 */
		function recyclerDump():void;
		
		/**
		 * On Collected from Recycler
		 * @param	...args
		 */
		function recyclerCollect(... args:Array):void;
	
	}

}