package gate.sirius.file {
	
	import flash.display.Loader;
	import flash.utils.setTimeout;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.UncaughtErrorEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import flash.system.LoaderContext;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SimpleLoader {
		
		/** @private */
		static private var _instances:Dictionary = new Dictionary(true); // Prevents the GC to kill current load proccess
		
		static private var _dataFlushed:Dictionary = new Dictionary(true);
		
		static protected var _securityAvoid:Dictionary = new Dictionary(true);
		
		
		static public function flush(name:String, data:ByteArray):void {
			_dataFlushed[name] = data;
		}
		
		
		static public function read(name:String):ByteArray {
			return _dataFlushed[name];
		}
		
		/** @private */
		private var _request:*;
		
		/** @private */
		private var _type:Class;
		
		/** @private */
		private var _progress:Number;
		
		/** @private */
		private var _isLoaded:Boolean;
		
		/** @private */
		private var _loader:*;
		
		/** @private */
		private var _error:String;
		
		/** @private */
		private var _errorID:int;
		
		/** @private */
		protected var _binary:Boolean;
		
		/** @private */
		protected var _context:LoaderContext;
		
		/** @private */
		protected var _steps:int;
		
		/** @private */
		protected var _currentStep:int;
		
		/**
		 * Sinal executado ao finalizar/falhar o carregamento de arquivos
		 */
		public var onComplete:Function;
		
		/**
		 * Sinal executado durante o carregamento de arquivos
		 */
		public var onProgress:Function;
		
		
		/**
		 * Cria um novo carregador simplificado de arquivos
		 * @param	request
		 * @param	type
		 * @param	onComplete
		 * @param	onProgress
		 * @return
		 */
		static public function load(request:*, type:Class, onComplete:Function = null, onProgress:Function = null):SimpleLoader {
			return new SimpleLoader(request, type, onComplete, onProgress);
		}
		
		
		/** @private */
		private function _addListeners(target:*):void {
			target.addEventListener(Event.COMPLETE, _onComplete, false, 0, true);
			target.addEventListener(ProgressEvent.PROGRESS, _onProgress, false, 0, true);
			target.addEventListener(IOErrorEvent.IO_ERROR, _onError, false, 0, true);
		}
		
		
		/** @private */
		static protected function _morphByteArray(loader:SimpleLoader):void {
			
			var callbackInfo:Object = _securityAvoid[loader];
			
			delete _securityAvoid[loader];
			
			if (callbackInfo.isText) {
				loader.onComplete = callbackInfo.handler;
				var bytes:ByteArray = loader.content as ByteArray;
				loader._loader.content = bytes.readUTFBytes(bytes.length);
				callbackInfo.handler(loader);
			} else {
				_instances[loader] = loader;
				loader._currentStep = 2;
				loader._binary = false;
				loader._type = Loader;
				loader._request = loader.content;
				loader.onComplete = callbackInfo.handler;
				setTimeout(loader._startLoad, 100);
			}
		
		}
		
		
		/** @private */
		private function _removeListeners(target:*):void {
			
			delete _instances[this];
			
			target.removeEventListener(Event.COMPLETE, _onComplete);
			target.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
			target.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
		
		}
		
		
		/** @private */
		private function _startLoad():void {
			
			_loader = null;
			
			_isLoaded = false;
			
			_progress = 0;
			
			switch (_type) {
				
				case Loader:
					
					var l:Loader = new Loader();
					l.contentLoaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, _onUncaughtError, false, 0, true);
					_addListeners(l.contentLoaderInfo);
					_loader = l;
					
					break;
				
				case URLLoader:
					
					var u:URLLoader = new URLLoader();
					if (_binary) {
						u.dataFormat = URLLoaderDataFormat.BINARY;
					}
					_addListeners(u);
					_loader = u;
					
					break;
				
				default:
					
					throw new Error("Class " + _type + " for SimpleLoader.type is not valid");
			
			}
			
			if (_request is ByteArray) {
				
				(_loader as Loader).loadBytes(_request, _context);
				
			} else {
				
				var req:URLRequest = _request is URLRequest ? _request : new URLRequest(_request);
				
				if (_context && _loader is Loader) {
					(_loader as Loader).load(req, _context);
				} else {
					_loader.load(req);
				}
				
			}
		
		}
		
		
		protected function _onUncaughtError(e:UncaughtErrorEvent):void {
		
		}
		
		
		/** @private */
		private function _onComplete(e:Event):void {
			
			_isLoaded = true;
			_request;
			if (onComplete !== null)
				onComplete(this);
			
			_removeListeners(e.target);
		
		}
		
		
		/** @private */
		private function _onProgress(e:ProgressEvent):void {
			
			if (e.bytesTotal == 0)
				_progress += .01;
			else
				_progress = e.bytesLoaded / e.bytesTotal;
			
			if (_progress > 1)
				_progress = 1;
			
			if (onProgress !== null)
				onProgress(this);
		
		}
		
		
		/** @private */
		private function _onError(e:IOErrorEvent):void {
			
			_error = e.text;
			
			_errorID = e.errorID;
			
			if (onComplete !== null)
				onComplete(this);
			
			_removeListeners(e.target);
		
		}
		
		
		/**
		 * Permite carregar um arquivo de forma prática
		 * @param	request
		 * @param	type
		 * @param	onComplete
		 * @param	onProgress
		 */
		public function SimpleLoader(request:*, type:Class, onComplete:Function = null, onProgress:Function = null, binary:Boolean = false, context:LoaderContext = null):void {
			
			_steps = 1;
			
			_currentStep = 1;
			
			_context = context;
			
			_binary = binary;
			
			_instances[this] = this;
			
			_type = type;
			
			_request = request;
			
			this.onComplete = onComplete;
			
			this.onProgress = onProgress;
			
			_startLoad();
		
		}
		
		
		/**
		 * Verifica se o carregamento foi concluído com successo
		 */
		public function get isLoaded():Boolean {
			return _isLoaded;
		}
		
		
		/**
		 * Progresso do carregamento
		 */
		public function get progress():Number {
			return _progress * _currentStep / _steps;
		}
		
		
		/**
		 * Conteúdo do carregamento
		 */
		public function get content():* {
			
			if (_loader is Loader) {
				
				return _loader.content;
				
			} else if (_loader is URLLoader) {
				
				return _loader.data;
				
			}
			
			return null;
		
		}
		
		
		public function get error():String {
			return _error;
		}
		
		
		public function get currentStep():int {
			return _currentStep;
		}
		
		
		public function get url():String {
			return (_request is URLRequest) ? _request.url : _request;
		}
		
		
		/**
		 * Carrega um arquivo do tipo DisplayObject
		 * @param	request
		 * @param	onComplete
		 * @param	onProgress
		 * @return
		 */
		static public function object(request:*, onComplete:Function, onProgress:Function = null, context:LoaderContext = null):SimpleLoader {
			
			return new SimpleLoader(request, Loader, onComplete, onProgress, false, context);
		
		}
		
		
		/**
		 * Carrega um arquivo do tipo DisplayObject
		 * @param	request
		 * @param	onComplete
		 * @param	onProgress
		 * @return
		 */
		static public function binary(request:*, onComplete:Function, onProgress:Function = null):SimpleLoader {
			
			return new SimpleLoader(request, URLLoader, onComplete, onProgress, true);
		
		}
		
		
		/**
		 * Carrega um arquivo do tipo de dados
		 * @param	request
		 * @param	onComplete
		 * @param	onProgress
		 * @return
		 */
		static public function data(request:*, onComplete:Function, onProgress:Function = null, binary:Boolean = false):SimpleLoader {
			
			return new SimpleLoader(request, URLLoader, onComplete, onProgress, binary);
		
		}
		
		
		/**
		 *
		 * @param	byteArray
		 * @param	onComplete
		 * @param	onProgress
		 * @return
		 */
		static public function morph(byteArray:ByteArray, onComplete:Function, onProgress:Function, context:LoaderContext = null):SimpleLoader {
			
			return new SimpleLoader(byteArray, Loader, onComplete, onProgress, false, context);
		
		}
		
		
		/**
		 *
		 * @param	request
		 * @param	onComplete
		 * @param	onProgress
		 * @param	context
		 * @return
		 */
		static public function securityResolve(request:*, onComplete:Function, onProgress:Function, context:LoaderContext, isTextContent:Boolean = false):SimpleLoader {
			
			context.allowLoadBytesCodeExecution = true;
			context.allowCodeImport = true;
			
			var loader:SimpleLoader = new SimpleLoader(request, URLLoader, _morphByteArray, onProgress, true, context);
			if (!isTextContent) {
				loader._steps = 2;
			}
			_securityAvoid[loader] = {handler: onComplete, isText: isTextContent};
			
			return loader;
		
		}
	
	}

}