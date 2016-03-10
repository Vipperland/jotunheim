package gate.sirius.file.zip {
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	
	
	/**
	 * Represents a file contained in a ZIP archive.
	 */
	public class ZipFile implements IZipFile {
		
		protected var _versionHost:int = 0;
		
		protected var _versionNumber:String = "2.0";
		
		protected var _compressionMethod:int = 8;
		
		protected var _encrypted:Boolean = false;
		
		protected var _implodeDictSize:int = -1;
		
		protected var _implodeShannonFanoTrees:int = -1;
		
		protected var _deflateSpeedOption:int = -1;
		
		protected var _hasDataDescriptor:Boolean = false;
		
		protected var _hasCompressedPatchedData:Boolean = false;
		
		protected var _date:Date;
		
		protected var _adler32:uint;
		
		protected var _hasAdler32:Boolean = false;
		
		protected var _sizeFilename:uint = 0;
		
		protected var _sizeExtra:uint = 0;
		
		protected var _filename:String = "";
		
		protected var _directory:String = "";
		
		protected var _extension:String = "";
		
		protected var _uri:String = "";
		
		protected var _filenameEncoding:String;
		
		protected var _extraFields:Dictionary;
		
		protected var _comment:String = "";
		
		protected var _content:ByteArray;
		
		internal var _crc32:uint;
		
		internal var _sizeCompressed:uint = 0;
		
		internal var _sizeUncompressed:uint = 0;
		
		protected var isCompressed:Boolean = false;
		
		protected var parseFunc:Function = _parseFileHead;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_NONE:int = 0;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_SHRUNK:int = 1;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_REDUCED_1:int = 2;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_REDUCED_2:int = 3;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_REDUCED_3:int = 4;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_REDUCED_4:int = 5;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_IMPLODED:int = 6;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_TOKENIZED:int = 7;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_DEFLATED:int = 8;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_DEFLATED_EXT:int = 9;
		
		/**
		 * @private
		 */
		public static const COMPRESSION_IMPLODED_PKWARE:int = 10;
		
		/**
		 * @private
		 */
		protected static var HAS_UNCOMPRESS:Boolean = (describeType(ByteArray).factory.method.(@name == "uncompress").parameter.length() > 0);
		
		/**
		 * @private
		 */
		protected static var HAS_INFLATE:Boolean = (describeType(ByteArray).factory.method.(@name == "inflate").length() > 0);
		
		
		/**
		 * Constructor
		 */
		public function ZipFile(filenameEncoding:String = "utf-8") {
			_filenameEncoding = filenameEncoding;
			_extraFields = new Dictionary();
			_content = new ByteArray();
			_content.endian = Endian.BIG_ENDIAN;
		}
		
		
		/**
		 * The Date and time the file was created.
		 */
		public function get date():Date {
			return _date;
		}
		
		
		public function set date(value:Date):void {
			_date = (value != null) ? value : new Date();
		}
		
		
		public function get isDirectory():Boolean {
			return filename.length == 0;
		}
		
		
		/**
		 * The file name (including relative path).
		 */
		public function get filename():String {
			return _filename;
		}
		
		
		public function set filename(value:String):void {
			var data:Array = value.split("/");
			_filename = data.pop();
			_directory = data[data.length - 1];
			_uri = data.join("/");
			data = _filename.split(".");
			_extension = data.length > 1 ? data.pop() : "";
		}
		
		
		/**
		 * Whether this file has a data descriptor or not (only used internally).
		 */
		internal function get hasDataDescriptor():Boolean {
			return _hasDataDescriptor;
		}
		
		
		/**
		 * The raw, uncompressed file.
		 */
		public function get content():ByteArray {
			if (isCompressed) {
				_uncompress();
			}
			return _content;
		}
		
		
		/**
		 * The ZIP specification version supported by the software
		 * used to encode the file.
		 */
		public function get versionNumber():String {
			return _versionNumber;
		}
		
		
		/**
		 * The size of the compressed file (in bytes).
		 */
		public function get sizeCompressed():uint {
			return _sizeCompressed;
		}
		
		
		/**
		 * The size of the uncompressed file (in bytes).
		 */
		public function get sizeUncompressed():uint {
			return _sizeUncompressed;
		}
		
		
		/**
		 * Gets the files content as string.
		 *
		 * @param recompress If <code>true</code>, the raw file content
		 * is recompressed after decoding the string.
		 *
		 * @param charset The character set used for decoding.
		 *
		 * @return The file as string.
		 */
		public function getContentAsString(recompress:Boolean = true, charset:String = "utf-8"):String {
			if (isCompressed) {
				_uncompress();
			}
			_content.position = 0;
			var str:String;
			if (charset == "utf-8") {
				str = _content.readUTFBytes(_content.bytesAvailable);
			} else {
				str = _content.readMultiByte(_content.bytesAvailable, charset);
			}
			_content.position = 0;
			if (recompress) {
				_compress();
			}
			return str;
		}
		
		
		/**
		 * @private
		 */
		internal function parse(stream:IDataInput):Boolean {
			while (stream.bytesAvailable && parseFunc(stream)) {
			}
			return (parseFunc === _parseFileIdle);
		}
		
		
		/**
		 * @private
		 */
		protected function _parseFileIdle(stream:IDataInput):Boolean {
			return false;
		}
		
		
		/**
		 * @private
		 */
		protected function _parseFileHead(stream:IDataInput):Boolean {
			if (stream.bytesAvailable >= 30) {
				_parseHead(stream);
				if (_sizeFilename + _sizeExtra > 0) {
					parseFunc = _parseFileHeadExt;
				} else {
					parseFunc = _parseFileContent;
				}
				return true;
			}
			return false;
		}
		
		
		/**
		 * @private
		 */
		protected function _parseFileHeadExt(stream:IDataInput):Boolean {
			if (stream.bytesAvailable >= _sizeFilename + _sizeExtra) {
				_parseHeadExt(stream);
				parseFunc = _parseFileContent;
				return true;
			}
			return false;
		}
		
		
		/**
		 * @private
		 */
		protected function _parseFileContent(stream:IDataInput):Boolean {
			var continueParsing:Boolean = true;
			if (_hasDataDescriptor) {
				parseFunc = _parseFileIdle;
				continueParsing = false;
			} else if (_sizeCompressed == 0) {
				parseFunc = _parseFileIdle;
			} else if (stream.bytesAvailable >= _sizeCompressed) {
				parseContent(stream);
				parseFunc = _parseFileIdle;
			} else {
				continueParsing = false;
			}
			return continueParsing;
		}
		
		
		/**
		 * @private
		 */
		protected function _parseHead(data:IDataInput):void {
			var vSrc:uint = data.readUnsignedShort();
			_versionHost = vSrc >> 8;
			_versionNumber = Math.floor((vSrc & 0xff) / 10) + "." + ((vSrc & 0xff) % 10);
			var flag:uint = data.readUnsignedShort();
			_compressionMethod = data.readUnsignedShort();
			_encrypted = (flag & 0x01) !== 0;
			_hasDataDescriptor = (flag & 0x08) !== 0;
			_hasCompressedPatchedData = (flag & 0x20) !== 0;
			if ((flag & 800) !== 0) {
				_filenameEncoding = "utf-8";
			}
			if (_compressionMethod === COMPRESSION_IMPLODED) {
				_implodeDictSize = (flag & 0x02) !== 0 ? 8192 : 4096;
				_implodeShannonFanoTrees = (flag & 0x04) !== 0 ? 3 : 2;
			} else if (_compressionMethod === COMPRESSION_DEFLATED) {
				_deflateSpeedOption = (flag & 0x06) >> 1;
			}
			var msdosTime:uint = data.readUnsignedShort();
			var msdosDate:uint = data.readUnsignedShort();
			var sec:int = (msdosTime & 0x001f);
			var min:int = (msdosTime & 0x07e0) >> 5;
			var hour:int = (msdosTime & 0xf800) >> 11;
			var day:int = (msdosDate & 0x001f);
			var month:int = (msdosDate & 0x01e0) >> 5;
			var year:int = ((msdosDate & 0xfe00) >> 9) + 1980;
			_date = new Date(year, month - 1, day, hour, min, sec, 0);
			_crc32 = data.readUnsignedInt();
			_sizeCompressed = data.readUnsignedInt();
			_sizeUncompressed = data.readUnsignedInt();
			_sizeFilename = data.readUnsignedShort();
			_sizeExtra = data.readUnsignedShort();
		}
		
		
		/**
		 * @private
		 */
		protected function _parseHeadExt(data:IDataInput):void {
			if (_filenameEncoding == "utf-8") {
				filename = data.readUTFBytes(_sizeFilename);
			} else {
				filename = data.readMultiByte(_sizeFilename, _filenameEncoding);
			}
			var bytesLeft:uint = _sizeExtra;
			while (bytesLeft > 4) {
				var headerId:uint = data.readUnsignedShort();
				var dataSize:uint = data.readUnsignedShort();
				if (dataSize > bytesLeft) {
					throw new Error("Parse error in file " + _filename + ": Extra field data size too big.");
				}
				if (headerId === 0xdada && dataSize === 4) {
					_adler32 = data.readUnsignedInt();
					_hasAdler32 = true;
				} else if (dataSize > 0) {
					var extraBytes:ByteArray = new ByteArray();
					data.readBytes(extraBytes, 0, dataSize);
					_extraFields[headerId] = extraBytes;
				}
				bytesLeft -= dataSize + 4;
			}
			if (bytesLeft > 0) {
				data.readBytes(new ByteArray(), 0, bytesLeft);
			}
		}
		
		
		/**
		 * @private
		 */
		internal function parseContent(data:IDataInput):void {
			if (_compressionMethod === COMPRESSION_DEFLATED && !_encrypted) {
				if (HAS_UNCOMPRESS || HAS_INFLATE) {
					data.readBytes(_content, 0, _sizeCompressed);
				} else if (_hasAdler32) {
					_content.writeByte(0x78);
					var flg:uint = (~_deflateSpeedOption << 6) & 0xc0;
					flg += 31 - (((0x78 << 8) | flg) % 31);
					_content.writeByte(flg);
					data.readBytes(_content, 2, _sizeCompressed);
					_content.position = _content.length;
					_content.writeUnsignedInt(_adler32);
				} else {
					throw new Error("Adler32 checksum not found.");
				}
				isCompressed = true;
			} else if (_compressionMethod == COMPRESSION_NONE) {
				data.readBytes(_content, 0, _sizeCompressed);
				isCompressed = false;
			} else {
				throw new Error("Compression method " + _compressionMethod + " is not supported.");
			}
			_content.position = 0;
		}
		
		
		/**
		 * @private
		 */
		protected function _compress():void {
			if (!isCompressed) {
				if (_content.length > 0) {
					_content.position = 0;
					_sizeUncompressed = _content.length;
					if (HAS_INFLATE) {
						_content.deflate();
						_sizeCompressed = _content.length;
					} else if (HAS_UNCOMPRESS) {
						_content.compress.apply(_content, ["deflate"]);
						_sizeCompressed = _content.length;
					} else {
						_content.compress();
						_sizeCompressed = _content.length - 6;
					}
					_content.position = 0;
					isCompressed = true;
				} else {
					_sizeCompressed = 0;
					_sizeUncompressed = 0;
				}
			}
		}
		
		
		/**
		 * @private
		 */
		protected function _uncompress():void {
			if (isCompressed && _content.length > 0) {
				_content.position = 0;
				if (HAS_INFLATE) {
					_content.inflate();
				} else if (HAS_UNCOMPRESS) {
					_content.uncompress.apply(_content, ["deflate"]);
				} else {
					_content.uncompress();
				}
				_content.position = 0;
				isCompressed = false;
			}
		}
		
		
		/**
		 * Returns a string representation of the ZipFile object.
		 */
		public function toString():String {
			return "[ZipFile]" + "\n  name:" + _filename + "\n  date:" + _date + "\n  sizeCompressed:" + _sizeCompressed + "\n  sizeUncompressed:" + _sizeUncompressed + "\n  versionHost:" + _versionHost + "\n  versionNumber:" + _versionNumber + "\n  compressionMethod:" + _compressionMethod + "\n  encrypted:" + _encrypted + "\n  hasDataDescriptor:" + _hasDataDescriptor + "\n  hasCompressedPatchedData:" + _hasCompressedPatchedData + "\n  filenameEncoding:" + _filenameEncoding + "\n  crc32:" + _crc32.toString(16) + "\n  adler32:" + _adler32.toString(16);
		}
		
		
		/* INTERFACE alchemy.vipperland.hydra.file.zip.IZipFile */
		
		public function dispose():void {
			if (_content) {
				_content.clear();
				_content = null;
			}
			_date = null;
			_comment = null;
			_filename = null;
			_extraFields = null;
			parseFunc = null;
		}
		
		/* INTERFACE gate.sirius.file.zip.IZipFile */
		
		public function get directory():String {
			return _directory;
		}
		
		
		/* INTERFACE gate.sirius.file.zip.IZipFile */
		
		public function get uri():String {
			return _uri;
		}
		
		
		public function get extension():String {
			return _extension;
		}
	}
}