package gate.sirius.file {
	import flash.events.IOErrorEvent;
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public interface IFileInfo {
		
		/**
		 * File name
		 */
		function get name():String;
		function get extension():String;
		
		/**
		 * File URI
		 */
		function get uri():*;
		
		/**
		 * File type
		 */
		function get type():String;
		
		/**
		 * Load error (if available)
		 */
		function get error():*;
		function set error(value:*):void;
		
		/**
		 * Load duration
		 */
		function get time():int;
		function set time(value:int):void;
		
		/**
		 * Content of the file (if loaded)
		 */
		function get content():*;
		function set content(value:*):void;
		
		/**
		 * File extra properties
		 */
		function get extra():Object;
		
		/**
		 * Clear FileInfo data
		 */
		function dispose():void;
	
	}

}