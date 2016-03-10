package gate.sirius.file.zip {
	
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import gate.sirius.file.zip.signals.ZipSignal;
	import gate.sirius.file.zip.signals.ZipSignals;
	
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	
	
	public class Zip implements IZip {
		
		protected var _filesList:Vector.<IZipFile>;
		
		protected var _filesDict:Dictionary;
		
		protected var _urlStream:URLStream;
		
		protected var _charEncoding:String;
		
		protected var _parseFunc:Function;
		
		protected var _currentFile:ZipFile;
		
		protected var _ddBuffer:ByteArray;
		
		protected var _ddSignature:uint;
		
		protected var _ddCompressedSize:uint;
		
		protected var _error:String;
		
		protected var _currentProgress:Number;
		
		protected var _name:String;
		
		protected var _hasError:IOErrorEvent;
		
		protected var _fileSize:uint;
		
		protected var _signals:ZipSignals;
		
		internal static const SIG_CENTRAL_FILE_HEADER:uint = 0x02014b50;
		
		internal static const SIG_SPANNING_MARKER:uint = 0x30304b50;
		
		internal static const SIG_LOCAL_FILE_HEADER:uint = 0x04034b50;
		
		internal static const SIG_DIGITAL_SIGNATURE:uint = 0x05054b50;
		
		internal static const SIG_END_OF_CENTRAL_DIRECTORY:uint = 0x06054b50;
		
		internal static const SIG_ZIP64_END_OF_CENTRAL_DIRECTORY:uint = 0x06064b50;
		
		internal static const SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR:uint = 0x07064b50;
		
		internal static const SIG_DATA_DESCRIPTOR:uint = 0x08074b50;
		
		internal static const SIG_ARCHIVE_EXTRA_DATA:uint = 0x08064b50;
		
		internal static const SIG_SPANNING:uint = 0x08074b50;
		
		
		protected function _parse(stream:IDataInput):Boolean {
			while (_parseFunc(stream)) {
			}
			return (_parseFunc === _parseIdle);
		}
		
		
		protected function _parseIdle(stream:IDataInput):Boolean {
			return false;
		}
		
		
		protected function _parseSignature(stream:IDataInput):Boolean {
			if (stream.bytesAvailable >= 4) {
				var sig:uint = stream.readUnsignedInt();
				switch (sig) {
					case SIG_LOCAL_FILE_HEADER: 
						_parseFunc = _parseLocalFile;
						_currentFile = new ZipFile(_charEncoding);
						break;
					case SIG_CENTRAL_FILE_HEADER: 
					case SIG_END_OF_CENTRAL_DIRECTORY: 
					case SIG_SPANNING_MARKER: 
					case SIG_DIGITAL_SIGNATURE: 
					case SIG_ZIP64_END_OF_CENTRAL_DIRECTORY: 
					case SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR: 
					case SIG_DATA_DESCRIPTOR: 
					case SIG_ARCHIVE_EXTRA_DATA: 
					case SIG_SPANNING: 
						_parseFunc = _parseIdle;
						break;
					default: 
						throw(new Error("Unknown record signature: 0x" + sig.toString(16)));
						break;
				}
				return true;
			}
			return false;
		}
		
		
		protected function _parseLocalFile(stream:IDataInput):Boolean {
			if (_currentFile.parse(stream)) {
				if (_currentFile.hasDataDescriptor) {
					_parseFunc = _findDataDescriptor;
					_ddBuffer = new ByteArray();
					_ddSignature = 0;
					_ddCompressedSize = 0;
					return true;
					
				} else {
					
					_onSingleFileLoaded();
					
					if (_parseFunc != _parseIdle) {
						_parseFunc = _parseSignature;
						return true;
						
					}
				}
			}
			return false;
		}
		
		
		protected function _findDataDescriptor(stream:IDataInput):Boolean {
			while (stream.bytesAvailable > 0) {
				var c:uint = stream.readUnsignedByte();
				_ddSignature = (_ddSignature >>> 8) | (c << 24);
				if (_ddSignature == SIG_DATA_DESCRIPTOR) {
					_ddBuffer.length -= 3;
					_parseFunc = _validateDataDescriptor;
					return true;
				}
				_ddBuffer.writeByte(c);
			}
			return false;
		}
		
		
		protected function _validateDataDescriptor(stream:IDataInput):Boolean {
			if (stream.bytesAvailable >= 12) {
				var ddCRC32:uint = stream.readUnsignedInt();
				var ddSizeCompressed:uint = stream.readUnsignedInt();
				var ddSizeUncompressed:uint = stream.readUnsignedInt();
				if (_ddBuffer.length == ddSizeCompressed) {
					_ddBuffer.position = 0;
					_currentFile._crc32 = ddCRC32;
					_currentFile._sizeCompressed = ddSizeCompressed;
					_currentFile._sizeUncompressed = ddSizeUncompressed;
					_currentFile.parseContent(_ddBuffer);
					_onSingleFileLoaded();
					_parseFunc = _parseSignature;
				} else {
					_ddBuffer.writeUnsignedInt(ddCRC32);
					_ddBuffer.writeUnsignedInt(ddSizeCompressed);
					_ddBuffer.writeUnsignedInt(ddSizeUncompressed);
					_parseFunc = _findDataDescriptor;
				}
				return true;
			}
			return false;
		}
		
		
		/**
		 * @private
		 */
		protected function _onSingleFileLoaded():void {
			_filesList[_filesList.length] = _currentFile;
			if (_currentFile.filename) {
				_filesDict[_currentFile.filename] = _currentFile;
			}
			_signals.FILE_LOADED.send(ZipSignal, true, ZipSignal.FILE_LOADED);
			_currentFile = null;
		}
		
		
		/**
		 * @private
		 */
		protected function _onFileLoadProgress(e:ProgressEvent):void {
			_currentProgress = e.bytesLoaded / e.bytesTotal;
			var ic:Boolean;
			_signals.PROGRESS.send(ZipSignal, true, ZipSignal.PROGRESS);
			try {
				if (_parse(_urlStream)) {
					ic = true;
					close();
				}
			} catch (e:Error) {
				_error = "parseError";
			}
			if (ic) {
				_signals.COMPLETE.send(ZipSignal, true, ZipSignal.COMPLETE);
			}
		}
		
		
		public function Zip(name:String = "", filenameEncoding:String = "utf-8") {
			_name = name;
			_charEncoding = filenameEncoding;
			_parseFunc = _parseIdle;
			_signals = new ZipSignals(this);
		}
		
		
		/**
		 * Parser activity
		 */
		public function get active():Boolean {
			return (_parseFunc !== _parseIdle);
		}
		
		
		/**
		 * Parser or load error code
		 */
		public function get errorCode():String {
			return _error;
		}
		
		
		/**
		 * Load a ZIP file
		 * @param	request
		 */
		public function load(url:*):void {
			
			if (!_urlStream && _parseFunc == _parseIdle) {
				if (!(url is URLRequest)) {
					url = new URLRequest(url);
				}
				_urlStream = new URLStream();
				_urlStream.endian = Endian.LITTLE_ENDIAN;
				_urlStream.addEventListener(ProgressEvent.PROGRESS, _onFileLoadProgress);
				_urlStream.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError, false, 0, true);
				_filesList = new Vector.<IZipFile>;
				_filesDict = new Dictionary();
				_parseFunc = _parseSignature;
				_urlStream.load(url);
			}
		
		}
		
		
		protected function _onLoadError(e:IOErrorEvent):void {
			_hasError = e;
			_signals.COMPLETE.send(ZipSignal, true, ZipSignal.COMPLETE);
		}
		
		
		/**
		 * Load a byte array
		 * @param	bytes
		 */
		public function loadBytes(bytes:ByteArray):void {
			if (!_urlStream && _parseFunc == _parseIdle) {
				_filesList = new Vector.<IZipFile>;
				_filesDict = new Dictionary();
				bytes.position = 0;
				bytes.endian = Endian.LITTLE_ENDIAN;
				_parseFunc = _parseSignature;
				if (_parse(bytes)) {
					_parseFunc = _parseIdle;
					_error = null;
				} else {
					_error = "parseError";
				}
				if (_urlStream && _urlStream.hasOwnProperty("bytesAvailable")) {
					_fileSize = _urlStream['bytesAvailable'];
				}
				_signals.COMPLETE.send(ZipSignal, true, ZipSignal.COMPLETE);
				close();
			}
		}
		
		
		/**
		 * Stop the load and close the stream
		 */
		public function close():void {
			if (_urlStream) {
				_parseFunc = _parseIdle;
				_urlStream.removeEventListener(ProgressEvent.PROGRESS, _onFileLoadProgress);
				_urlStream.removeEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
				_urlStream.close();
				_urlStream = null;
			}
		}
		
		
		public function dispose():void {
			
			close();
			
			for each (var f:IZipFile in _filesList) {
				f.dispose();
			}
			
			_filesList = null;
			_filesDict = null;
			_parseFunc = null;
			_currentFile = null;
			if (_ddBuffer) {
				_ddBuffer.clear()
				_ddBuffer = null;
			}
			_error = null;
			_name = null;
			_hasError = null;
		}
		
		
		/**
		 * Total of files
		 * @return
		 */
		public function get length():uint {
			return _filesList ? _filesList.length : 0;
		}
		
		
		/**
		 * Last parsed file
		 */
		public function get currentFile():IZipFile {
			return _currentFile as IZipFile;
		}
		
		
		/**
		 * Get a file by index
		 * @param	index
		 * @return
		 */
		public function getFileAt(index:uint):IZipFile {
			return _filesList ? _filesList[index] as IZipFile : null;
		}
		
		
		/**
		 * Get a file by name
		 * @param	name
		 * @return
		 */
		public function getFileByName(name:String):IZipFile {
			return _filesDict[name] ? _filesDict[name] as IZipFile : null;
		}
		
		
		/**
		 * Parsed files list
		 */
		public function get files():Vector.<IZipFile> {
			return _filesList;
		}
		
		
		public function get name():String {
			return _name;
		}
		
		
		public function get loadError():IOErrorEvent {
			return _hasError;
		}
		
		
		public function get fileSize():uint {
			return _fileSize;
		}
		
		
		public function get currentProgress():Number {
			return _currentProgress;
		}
		
		
		public function get signals():ZipSignals {
			return _signals;
		}
	
	}

}