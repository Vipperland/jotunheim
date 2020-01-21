package gate.sirius.file {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import gate.sirius.file.signals.ILoaderSignals;
	import gate.sirius.file.signals.LoaderSignal;
	import gate.sirius.file.signals.LoaderSignals;
	import gate.sirius.isometric.recycler.Recycler;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SequentialLoader implements ISequentialLoader {
		
		private static var _bin:Dictionary = new Dictionary(false);
		
		private static var _extra:Object = {};
		
		public static function get extra():Object {
			return _extra;
		}
		
		public static function holdFile(name:String, content:*):void {
			_bin[name] = content;
		}
		
		public static function releaseFile(name:String):* {
			var content:* = _bin[name];
			delete _bin[name];
			return content;
		}
		
		public static function get cachedFiles():Dictionary {
			return _bin;
		}
		
		/** @private */
		protected var _filesByName:Dictionary;
		
		/** @private */
		protected var _files:Vector.<IFileInfo>;
		
		/** @private */
		protected var _toLoad:Vector.<IFileInfo>;
		
		/** @private */
		protected var _loadedFiles:int;
		
		/** @private */
		protected var _loader:*;
		
		///** @private */
		protected var _isLoading:Boolean;
		
		/** @private */
		protected var _overallProgress:Number;
		
		/** @private */
		protected var _currentFileProgress:Number;
		
		/** @private */
		protected var _errors:int;
		
		/** @private */
		protected var _appDomain:LoaderContext;
		
		/** @private */
		protected var _totalBytes:int;
		
		/** @private */
		protected var _currentFileBytes:int;
		
		/** @private */
		protected var _parseTime:int;
		
		/** @private */
		protected var _stopped:Boolean;
		
		/** @private */
		protected var _signals:LoaderSignals;
		
		/** @private */
		private function _init():void {
			
			_filesByName = new Dictionary(true);
			
			_files = new Vector.<IFileInfo>();
			
			_toLoad = new Vector.<IFileInfo>();
			
			_signals = new LoaderSignals(this);
			
			_overallProgress = 0;
			
			_loadedFiles = 0;
			
			_errors = 0;
		
		}
		
		/** @private */
		private function _clearLoader():void {
			
			if (_loader) {
				_configListeners(_loader is Loader ? _loader.contentLoaderInfo : _loader, true);
				_loader = null;
			}
		
		}
		
		/** @private */
		private function _onLoadError(e:IOErrorEvent):void {
			_onLoadComplete(e, true);
		}
		
		/** @private */
		private function _onLoadProgress(e:ProgressEvent):void {
			
			_currentFileBytes = e.bytesTotal;
			
			_currentFileProgress = e.bytesLoaded / _currentFileBytes;
			
			_overallProgress = _loadedFiles / _files.length + _currentFileProgress / _files.length;
			
			_signals.LOAD_PROGRESS.send(LoaderSignal, true, LoaderSignal.PROGRESS);
		
		}
		
		/** @private */
		private function _onLoadComplete(e:Event, error:Boolean = false):void {
			
			var file:IFileInfo = _toLoad[0];
			
			file.time = getTimer() - _parseTime;
			
			if (error) {
				file.content = null;
				file.error = e;
				++_errors;
			} else {
				switch (file.type) {
					case FileType.IMAGE: 
					case FileType.SWF:
						file.content = _loader.content;
						break;
					case FileType.TEXT:
						file.content = _loader.data;
						break;
					case FileType.BINARY:
						if (file.uri is ByteArray) {
							file.content = _loader.content;
						} else {
							file.content = _loader.data;
						}
						break;
					default:
				}
				_totalBytes += _currentFileBytes;
			}
			
			++_loadedFiles;
			
			_updateProgress();
			
			_filesByName[file.name] = file;
			
			_signals.FILE_LOADED.send(LoaderSignal, false, LoaderSignal.FILE_LOADED);
			
			if (_stopped) {
				_stopped = false;
				_isLoading = false;
				return;
			}
			
			_toLoad.shift();
			
			if (_toLoad.length > 0) {
				_loadNextFile();
			} else {
				_filesLoaded();
			}
		
		}
		
		/** @private */
		private function _updateProgress():void {
			_overallProgress = _loadedFiles / _files.length;
		}
		
		/** @private */
		private function _onLoadOpen(e:Event):void {
			_signals.LOAD_START.send(LoaderSignal, false, LoaderSignal.START);
		}
		
		/** @private */
		private function _loadNextFile():void {
			
			_clearLoader();
			
			if (_toLoad.length == 0) {
				_filesLoaded();
				return;
			}
			
			_isLoading = true;
			
			var file:IFileInfo = _toLoad[0];
			var isBinary:Boolean;
			var useAppDomain:Boolean;
			
			switch (file.type) {
				
				case FileType.BINARY:
					
					if (file.uri is ByteArray) {
						
						isBinary = true;
						
					} else {
						
						isBinary = false;
						
						_loader = new URLLoader();
						_loader.dataFormat = URLLoaderDataFormat.BINARY;
						_configListeners(_loader, false);
						
						break;
						
					}
				
				case FileType.IMAGE: 
				case FileType.SWF:
					
					_loader = new Loader();
					_configListeners(_loader.contentLoaderInfo, false);
					useAppDomain = true;
					
					break;
				
				case FileType.MP3:
					
					_loader = new Sound();
					_configListeners(_loader, false);
				
				default:
					
					_loader = new URLLoader();
					_configListeners(_loader, false);
					
					break;
			
			}
			
			_parseTime = getTimer();
			
			if (isBinary) {
				try {
					if (useAppDomain) {
						(file.uri as ByteArray).position = 0;
						_loader.loadBytes(file.uri as ByteArray, _appDomain);
					} else {
						_loader.loadBytes(file.uri as ByteArray);
					}
				} catch (e:Error) {
					trace(file.name, e);
				}
			} else {
				try {
					if (useAppDomain && _appDomain)
						_loader.load(file.uri is URLRequest ? file.uri : new URLRequest(file.uri), _appDomain);
					else
						_loader.load(file.uri is URLRequest ? file.uri : new URLRequest(file.uri));
				} catch (e:Error) {
					file.error = e;
					trace("Error on load file.", e);
				}
			}
		
		}
		
		/** @private */
		protected function _filesLoaded():void {
			
			_clearLoader();
			
			_overallProgress = 1;
			
			_isLoading = false;
			
			_signals.LOAD_COMPLETE.send(LoaderSignal, false, LoaderSignal.COMPLETE);
			Recycler.GATE.discartAllOf(LoaderSignal);
		
		}
		
		/** @private */
		protected function _configListeners(target:*, remove:Boolean = false):void {
			
			if (!target)
				return;
			
			if (remove) {
				target.removeEventListener(Event.OPEN, _onLoadOpen);
				target.removeEventListener(Event.COMPLETE, _onLoadComplete);
				target.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
				target.removeEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
				return;
			}
			
			target.addEventListener(Event.OPEN, _onLoadOpen);
			target.addEventListener(Event.COMPLETE, _onLoadComplete);
			target.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			target.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
		
		}
		
		public function SequentialLoader() {
			_init();
		}
		
		/**
		 * Inicia o ciclo de carregamento
		 */
		public function start(context:LoaderContext = null):void {
			
			_appDomain = context;
			
			_stopped = false;
			
			if (_isLoading)
				return;
			
			_errors = 0;
			
			if (_toLoad.length == 0) {
				_overallProgress = 1;
				_signals.LOAD_COMPLETE.send(LoaderSignal, false, LoaderSignal.COMPLETE);
				return;
			}
			
			_loadNextFile();
		
		}
		
		/**
		 * Para o cicle de carregamento
		 */
		public function stop():void {
			
			_stopped = true;
			
			switch (_loader) {
				
				case Loader:
					
					_loader.unloadAndStop(true);
					break;
				
				case URLLoader: 
				case Sound:
					
					(_loader as URLLoader).close();
					break;
			
			}
			
			_clearLoader();
		
		}
		
		/**
		 * Remove um arquivo previamente carregado
		 * @param	name
		 */
		public function clear(name:String = null, dispose:Boolean = true):void {
			
			for each (var file:IFileInfo in _files) {
				
				if (!name || file.name == name) {
					if(dispose){
						if (file.content is Bitmap) {
							(file.content as Bitmap).bitmapData.dispose();
						}
						if (file.content is DisplayObject) {
							var flod:Loader = (file.content as DisplayObject).loaderInfo.loader;
							if (flod.hasOwnProperty('unloadAndStop')) {
								flod.unloadAndStop(true);
							} else {
								flod.unload();
							}
						}
						file.dispose();
					}
					delete _filesByName[file.name];
					_files.splice(_files.indexOf(file), 1);
					--_loadedFiles;
					_updateProgress();
					if (name) {
						return;
					}
				}
				
			}
			
			if (!name) {
				_clearLoader();
				_init();
			}
		
		}
		
		/**
		 * Adiciona um arquivo
		 * @param	name
		 * @param	url
		 */
		public function addFile(name:String, url:*, type:String = "auto", extra:Object = null):IFileInfo {
			
			if (url is ByteArray)
				type = FileType.BINARY;
			
			else if (type.length < 3 || !type)
				type = FileType.AUTO_DETECT;
			
			var smart:Boolean = type == FileType.SMART;
			
			if (type == FileType.AUTO_DETECT || smart) {
				
				var extArr:Array = url is URLRequest ? (url as URLRequest).url.split(".") : url.split(".");
				
				var ext:String = extArr[extArr.length - 1];
				
				ext = ext.toLowerCase();
				
				ext = ext.split("?").shift();
				
				switch (ext) {
					
					case "jpg": 
					case "png": 
					case "bmp": 
					case "gif":
						
						type = smart ? FileType.BINARY : FileType.IMAGE;
						break;
					
					case "swf":
						
						type = smart ? FileType.BINARY : FileType.SWF;
						break;
					
					case "mp3":					
					case "zip": 
					case "rar":
						
						type = FileType.BINARY;
						break;
					
					default:
						
						type = FileType.TEXT;
				
				}
				
			}
			
			var file:IFileInfo = new FileInfo(name, url, type, extra) as IFileInfo;
			
			_filesByName[name] = file;
			
			_files[_files.length] = file;
			
			_toLoad[_toLoad.length] = file;
			
			return file;
		
		}
		
		/**
		 * Retorna um arquivo pelo nome
		 * @param	name
		 * @return
		 */
		public function getFileByName(name:String):IFileInfo {
			if (!_filesByName[name])
				return null;
			return _filesByName[name];
		}
		
		/**
		 * Verifica existencia de um arquivo
		 * @param	name
		 * @return
		 */
		public function hasFile(name:String):Boolean {
			return _filesByName[name] !== undefined;
		}
		
		/**
		 * Verifica existencia de um conteúdo
		 * @param	name
		 * @return
		 */
		public function hasContent(name:String):Boolean {
			return _filesByName[name] && _filesByName[name].content !== null ? true : false;
		}
		
		/**
		 * Retorna arquivos carregados
		 * @return
		 */
		public function getLoadedFiles():Vector.<IFileInfo> {
			
			var r:Vector.<IFileInfo> = new Vector.<IFileInfo>();
			
			var file:*;
			
			for each (var fInfo:IFileInfo in _files) {
				
				file = _filesByName[fInfo.name];
				
				r[r.length] = file;
				
			}
			
			return r;
		
		}
		
		/**
		 * Filtra todos os arquivos por uma classe especifica
		 * @param	Filter
		 * @return
		 */
		public function getFilesByClass(Filter:Class):Array {
			
			var r:Array = new Array();
			
			var file:*;
			
			for each (var fInfo:IFileInfo in _files) {
				
				file = _filesByName[fInfo.name].content;
				
				if (file is Filter)
					r[r.length] = file;
				
			}
			
			return r;
		
		}
		
		/**
		 * List of all files data
		 */
		public function getFilesInfo():Vector.<IFileInfo> {
			return new Vector.<IFileInfo>().concat(_files);
		}
		
		/**
		 * Progresso do carregamento de todos os arquivos
		 */
		public function get loadCicleProgress():Number {
			return _overallProgress;
		}
		
		/**
		 * Total de arquivos
		 */
		public function get length():int {
			return _files.length;
		}
		
		/**
		 * Contagem de arquivos carregados
		 */
		public function get loadedFiles():int {
			return _loadedFiles;
		}
		
		/**
		 * Arquivo atual
		 */
		public function get currentFile():IFileInfo {
			if (_toLoad.length > 0)
				return _toLoad[0];
			return null;
		}
		
		/**
		 * Indica se todos os arquivos foram carregados
		 */
		public function get isComplete():Boolean {
			
			return _overallProgress == 1 && !_isLoading;
		
		}
		
		/**
		 * Progress of the current load
		 */
		public function get currentFileProgress():Number {
			return _currentFileProgress;
		}
		
		/**
		 * List of the names of added files
		 */
		public function get fileNames():Vector.<String> {
			
			var names:Vector.<String> = new Vector.<String>();
			for each (var file:IFileInfo in _files) {
				names[names.length] = file.name;
			}
			
			return names;
		
		}
		
		public function get totalBytes():int {
			return _totalBytes;
		}
		
		public function get shared():Object {
			return _extra;
		}
		
		public function get signals():ILoaderSignals {
			return _signals;
		}
		
		public function get totalErrors():int {
			return _errors;
		}
		
		public function dispose():void {
			clear();
			_filesByName = null;
			_files = null;
			_toLoad = null;
			_loader = null;
			_appDomain = null;
			_signals.dispose();
			_signals = null;
		}
	
	}

}