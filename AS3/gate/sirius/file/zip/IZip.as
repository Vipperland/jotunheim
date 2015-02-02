package gate.sirius.file.zip {
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import gate.sirius.file.zip.signals.ZipSignals;
	
	
	public interface IZip {
		
		/**
		 * File name
		 */
		function get name():String;
		
		/**
		 * Parser activity
		 */
		function get active():Boolean;
		
		/**
		 * File load progress
		 */
		function get currentProgress():Number;
		
		/**
		 * Parser or load error code
		 */
		function get errorCode():String;
		
		/**
		 * Last parsed file
		 */
		function get currentFile():IZipFile;
		
		/**
		 * Zip events
		 */
		function get signals():ZipSignals;
		
		/**
		 * Total of files
		 * @return
		 */
		function get length():uint;
		
		/**
		 * Load a ZIP file
		 * @param	request
		 */
		function load(url:*):void;
		
		/**
		 * Load a byte array
		 * @param	bytes
		 */
		function loadBytes(bytes:ByteArray):void;
		
		/**
		 * Stop the load and close the stream
		 */
		function close():void;
		
		/**
		 * Clear all data
		 */
		function dispose():void;
		
		/**
		 * Get a file by index
		 * @param	index
		 * @return
		 */
		function getFileAt(index:uint):IZipFile;
		
		/**
		 * Get a file by name
		 * @param	name
		 * @return
		 */
		function getFileByName(name:String):IZipFile;
		
		/**
		 * Loaded bytes
		 */
		function get fileSize():uint;
		
		/**
		 * Parsed files list
		 */
		function get files():Vector.<IZipFile>;
		
		/**
		 * Load error (if available)
		 */
		function get loadError():IOErrorEvent;
	
	}
}
