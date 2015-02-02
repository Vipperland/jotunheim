package gate.sirius.file.zip.swc {
	import alchemy.vipperland.hydra.file.zip.IZip;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public interface ISWCParser {
		
		/**
		 * Error stackTrace
		 */
		function get error():String;
		
		/**
		 * On render complete
		 */
		function get onComplete():Function;
		function set onComplete(value:Function):void;
		
		/**
		 * Add a loaded SWC component and extracts all library
		 * @param	zip
		 */
		function addSWC(zip:IZip, onComplete:Function = null):void;
		
		/**
		 * Return the specified class (if valid)
		 * @param	name
		 * @return
		 */
		function getClass(name:String):Class;
		
		/**
		 * Generates a instance of a class (if valid)
		 * @param	className
		 * @return
		 */
		function getInstanceOf(className:String):*;
		
		/**
		 * Return a Vector of all valid classes on the swc
		 * @return
		 */
		function findClassNames():Vector.<String>;
	
	}
}
