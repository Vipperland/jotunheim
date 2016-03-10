package gate.sirius.file.zip
{
	import flash.utils.ByteArray;

	/**
	 * Represents a file contained in a ZIP archive.
	 */
	public interface IZipFile
	{
		
		function get date () : Date;

		/**
		 * The file name
		 */
		function get filename () : String;
		
		/**
		 * The Parent directory name
		 */
		function get directory () : String;
		
		/**
		 * The file path
		 */
		function get uri () : String;

		/**
		 * The file extension
		 */
		function get extension () : String;

		/**
		 * The raw, uncompressed file.
		 */
		function get content () : ByteArray;

		/**
		 * The ZIP specification version supported by the software
		 * used to encode the file.
		 */
		function get versionNumber () : String;

		/**
		 * The size of the compressed file (in bytes).
		 */
		function get sizeCompressed () : uint;

		/**
		 * The size of the uncompressed file (in bytes).
		 */
		function get sizeUncompressed () : uint;
		
		function get isDirectory() : Boolean;
		
		/**
		 * Gets the files content as string.
		 * @param recompress If <code>true</code>, the raw file content
		 *   is recompressed after decoding the string.
		 * @param charset The character set used for decoding.
		 * @return The file as string.
		 */
		function getContentAsString (recompress:Boolean=true, charset:String="utf-8") : String;
		
		/**
		 * Returns a string representation of the ZipFile object.
		 */
		function toString () : String;
		
		function dispose():void;
		
	}
}
