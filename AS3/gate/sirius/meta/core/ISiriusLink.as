package gate.sirius.meta.core {
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public interface ISiriusLink {
		
		/**
		 * Add a command for Server Script
		 * @param	name
		 * @param	...params
		 */
		function runCommand(name:String, ... params:Array):void;
		
		/**
		 * Returns the command list
		 * @return
		 */
		function getCommands():Array;
		
		/**
		 * Print commands
		 * @param	identSize
		 * @return
		 */
		function dumpCommands(identSize:int = 1):String;
	
	}

}