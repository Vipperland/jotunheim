package gate.sirius.modloader {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import gate.sirius.file.FileType;
	import gate.sirius.file.IFileInfo;
	import gate.sirius.file.ISequentialLoader;
	import gate.sirius.file.SequentialLoader;
	import gate.sirius.file.signals.LoaderSignal;
	import gate.sirius.file.zip.IZip;
	import gate.sirius.file.zip.IZipFile;
	import gate.sirius.file.zip.signals.ZipSignal;
	import gate.sirius.file.zip.Zip;
	import gate.sirius.log.ULog;
	import gate.sirius.meta.Console;
	import gate.sirius.modloader.AssetCache;
	import gate.sirius.modloader.data.Mod;
	import gate.sirius.modloader.data.StartupData;
	import gate.sirius.modloader.signals.ResourceSignal;
	import gate.sirius.modloader.signals.ResourceSignals;
	import gate.sirius.serializer.signals.SruDecoderSignal;
	import gate.sirius.serializer.signals.SruErrorSignal;
	import gate.sirius.serializer.SruDecoder;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ModLoader {
		
		static public const STARTUP_DATA:uint = 0;
		
		static public const MOD_DATA:uint = 1;
		
		static public const RESOLVE_DATA:uint = 2;
		
		private var _IS_DESKTOP:Boolean;
		
		private var _cache:AssetCache;
		
		private var _mods:Dictionary;
		
		private var _path:String;
		
		private var _syncLoader:ISequentialLoader;
		
		private var _asyncAssetFileLoad:Dictionary;
		
		private var _parsedFileCount:uint;
		
		private var _loadPhase:uint;
		
		private var _current:Mod;
		
		private var _scannedMods:Vector.<String>;
		
		private var _signals:ResourceSignals;
		
		private var _config:StartupData;
		
		private var _compressedMod:IZip;
		
		private var _parser:SruDecoder;
		
		private var _parserTicket:Object;
		
		private var _context:LoaderContext;
		
		private var _extension:*;
		
		private var _toParseData:Array;
		
		private var _shared:Object;
		
		private var _logger:ULog = ULog.GATE;
		
		private function _initMobile():void {
			var dir:File = new File(File.applicationDirectory.resolvePath('data').nativePath);
			_startupMain(dir);
		}
		
		private function _preScan():void {
			_logger.pushMessage("[LOAD] Scanning Mods directory");
			var dir:File = new File(File.applicationDirectory.nativePath);
			if (dir.exists) {
				var res_dir:File = dir.resolvePath("resources");
				if (!res_dir.exists) {
					res_dir.createDirectory();
				}
				// Create /RESOURCE/DATA/
				var config_dir:File = res_dir.resolvePath("data");
				if (!config_dir.exists) {
					config_dir.createDirectory();
				}
				// Create /RESOURCE/MODS/
				var mods_dir:File = res_dir.resolvePath("mods");
				if (!mods_dir.exists) {
					mods_dir.createDirectory();
				}
				// Create /RESOURCE/MODS/LOADER/
				var loader:File = mods_dir.resolvePath("loader");
				if (!loader.exists) {
					loader.createDirectory();
					_config.createInfoFile(loader.resolvePath("info.sru"), "loader", "0.0.0", null, null, "UILoaderScreen");
				}
				// Create /RESOURCE/MODS/CORE/
				var core:File = mods_dir.resolvePath("core");
				if (!core.exists) {
					core.createDirectory();
				}
				
				for each (var file:File in mods_dir.getDirectoryListing()) {
					if (file.isDirectory) {
						var infoFile:File = file.resolvePath("info.sru");
						if (!infoFile.exists) {
							_config.createInfoFile(infoFile, file.name, "0.0.0", null, null, null);
						}
						_addModInfo(infoFile, file);
					} else if (file.extension.toLowerCase() == "zip") {
						_addCompreessedModInfo(file);
					}
				}
				
				_startupMain(config_dir);
				
			} else {
				_logger.pushError("[LOAD] Critical: Game instalation directory not found.");
			}
		}
		
		
		private function _addCompreessedModInfo(file:File):void {
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var zipData:ByteArray = new ByteArray();
			fs.readBytes(zipData, 0, fs.bytesAvailable);
			fs.close();
			_path = file.nativePath;
			_compressedMod = new Zip();
			_compressedMod.signals.FILE_LOADED.hold(_onCompressedModFileLoaded);
			_compressedMod.loadBytes(zipData);
		}
		
		
		private function _onCompressedModFileLoaded(signal:ZipSignal):void {
			var file:IZipFile = signal.file;
			if (file.isDirectory) {
				return;
			} else if (file.filename == "info.sru") {
				_parser.parse(file.getContentAsString(), _parserTicket, null, _sruParserError, file.filename);
			} else if (file.extension == "sru") {
				_toParseData[_toParseData.length] = file;
			} else {
				
			}
		}
		
		
		private function _addModInfo(infoFile:File, file:File):void {
			var fs:FileStream = new FileStream();
			fs.open(infoFile, FileMode.READ);
			var content:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			_path = file.nativePath;
			_parser.parse(content, _parserTicket, null, _sruParserError, infoFile.name);
		}
		
		
		private function _startupMain(config:File):void {
			var configData:String = _config.checkFile(config.resolvePath("config.sru"));
			_parser.parse(configData, _config, null, _sruParserError, "config.sru");
			for each (var file:File in config.getDirectoryListing()) {
				if (file.extension == "sru") {
					_syncLoader.addFile("startup=" + file.name, file.nativePath, FileType.TEXT, {asset: false, data: true, mod: null, skip: true});
				}
			}
			_syncLoader.start();
		}
		
		
		private function _scanDir(mod:Mod, dir:File, type:String, data:Object, count:int):int {
			var list:Array = dir.getDirectoryListing();
			for each (var file:File in list) {
				if (file.isDirectory){
					count += _scanDir(mod, file, type, data, count);
				}else{
					_syncLoader.addFile(mod.id + "=" + file.name, file.nativePath, type, data);
					mod.files += 1;
					count += 1;
				}
			}
			return count;
		}
		
		private function _scanMod(mod:Mod):Mod {
			
			var dir:File;
			
			if (mod.dependencies.length > 0) {
				for each (var dependency:String in mod.dependencies) {
					if (_scannedMods.indexOf(dependency) == -1) {
						_logger.pushWarning("Mod [" + mod.id + "] should be load after [" + dependency + "]");
					} else {
						_logger.pushMessage("   Dependency Mod @" + dependency + " found.");
					}
				}
			}
			
			if (mod.compressed) {
				
				var assetsCount:uint = 0;
				var dataCount:uint = 0;
				var assets:Array = [];
				
				for each (var cfile:IZipFile in mod.compressed.files) {
					
					if (cfile.isDirectory) 
						continue;
					
					switch(cfile.uri.split('/', 1)[0]){
						case 'assets' : {
							assets[assets.length] = [mod.id + "=" + cfile.filename, cfile.content, FileType.BINARY, {asset: true, data: true, mod: mod}];
							break;
						}
						case 'data' : {
							++dataCount;
							_syncLoader.addFile(mod.id + "=" + cfile.filename, cfile.uri, FileType.TEXT, {asset: false, data: true, mod: mod});
							mod.files += 1;
							break;
						}
					}
					
				}
				
				for each (var assetFile:Array in assets) {
					++assetsCount;
					mod.files += 1;
					_syncLoader.addFile.apply(null, assetFile);
				}
				
				_logger.pushMessage("   Getting mod/assets/ files (" + assetsCount + ")");
				_logger.pushMessage("   Getting mod/data/ files (" + dataCount + ")");
				
			} else {
				
				var modlocation:File = new File(mod.path);
				var flen:int;
				
				// data directory
				dir = modlocation.resolvePath("data");
				
				if (!dir.exists) {
					dir.createDirectory();
				}else{
					flen = _scanDir(mod, dir, FileType.TEXT, {asset: false, data: true, mod: mod}, 0);
					_logger.pushMessage("   Added mod/data/ files (" + flen + ")");
				}
				
				// assets directory
				
				dir = modlocation.resolvePath("assets");
				if (!dir.exists) {
					dir.createDirectory();
				}else{
					flen = _scanDir(mod, dir, FileType.BINARY, {asset: true, data: false, mod: mod}, 0);
					_logger.pushMessage("   Added mod/assets/ files (" + flen + ")");
				}
				
			}
			
			_scannedMods[_scannedMods.length] = mod.id;
			
			return mod;
		}
		
		
		private function _sruParserError(signal:SruErrorSignal):void {
			_logger.pushError(signal.message);
		}
		
		
		private function _onSyncFileLoaded(signal:LoaderSignal):void {
			var file:IFileInfo = signal.loader.currentFile;
			var isByteArray:Boolean = file.content is ByteArray;
			var mod:Mod = file.extra.mod;
			if (mod != null){
				_current = mod;
			}
			if (!isByteArray) {
				_logger.pushMessage("   File " + file.name + " added (" + signal.loader.loadedFiles + "/" + signal.loader.length + ")");
			}
			if (file.error) {
				_logger.pushWarning((file.error as IOErrorEvent).text);
				if (mod != null){
					mod.loaded += 1;
				}
			} else if (file.extra.asset) {
				if (file.content is ByteArray) {
					if ((file.content as ByteArray).length > 0) {
						_syncLoader.addFile(file.name, file.content, FileType.AUTO_DETECT, file.extra);
					}
				} else {
					switch (file.extension) {
						case "swf":  {
							_cache.register(mod, (file.content as DisplayObject));
							break;
						}
						case "jpg":  {
						}
						case "bmp":  {
						}
						case "png":  {
							_cache.registerImage(mod, file.name, (file.content as Bitmap).bitmapData);
							break;
						}
					}
					if(mod != null){
						mod.loaded += 1;
						if (mod.isLoaded()) {
							if (mod.compressed){
								mod.compressed.dispose();
							}
							_initMod(mod);
						}
					}
					
				}
			} else {
				switch (file.extension) {
					case "sru":  {
						if (!file.extra.skip) {
							_toParseData[_toParseData.length] = file;
						}
						
					}
				}
				if (mod != null){
					mod.loaded += 1;
					if (mod.isLoaded()) {
						_initMod(mod);
					}
				}
			}
			++_parsedFileCount;
			_signals.ON_FILE.send(ResourceSignal, true, file);
		}
		
		
		private function _initMod(mod:Mod):void {
			if (mod.onload != null){
				mod.initialized = _cache.getInstance(_current.id + '=' + mod.onload);
				try {
					mod.initialized.Context = _shared;
					mod.initialized.Self = {
						_main:mod,
						show:function():void {
							_shared.viewport.ui.addChild(this._main.initialized);
						},
						hide:function():void {
							if (this._main.initialized.parent != null){
								this._main.initialized.parent.removeChild(this._main.initialized);
							}
						},
						dispose:function():void{
							this.hide();
							this._main.initialized.Context = null;
							this._main.initialized.Self = null;
							this._main.initialized = null;
						}
					};
					if (mod.initialized.OnInit != null){
						mod.initialized.OnInit();
					}
				}catch (e:Error){
					_logger.pushError('Error Dectected on Mod:[' + mod.id + ']');
					_logger.pushError(e.getStackTrace());
				}
			}
			_signals.ON_MOD_LOADED.send(ResourceSignal, true);
		}
		
		
		private function _onFileParseComplete(signal:SruDecoderSignal):void {
			++_parsedFileCount;
			_checkResourcesCompletion();
		}
		
		
		private function _checkResourcesCompletion():void {
			if (_parsedFileCount == _syncLoader.length && _syncLoader.isComplete) {
				_logger.pushMessage("[LOAD] Mod resources loaded");
				_validateModResources();
				_syncLoader.clear();
			}
		}
		
		
		private function _validateModResources():void {
			var fileInfo:IFileInfo;
			var zipFile:IZipFile;
			var missing:Vector.<String>;
			var targetMod:Mod;
			
			for each (var mod:Mod in _mods) {
				missing = mod.errors;
				for each (var dependency:String in mod.dependencies) {
					targetMod = _mods[dependency];
					if (!targetMod || !targetMod.enabled) {
						_logger.pushWarning("[LOAD] Mod dependency [" + dependency + "] is required by [" + mod.id + "]");
						missing[missing.length] = dependency;
					}
				}
			}
			
			for each (var data:* in _toParseData) {
				if (data is IFileInfo) {
					fileInfo = (data as IFileInfo);
					_parser.parse(fileInfo.content, _parserTicket, null, null, fileInfo.name);
					fileInfo.dispose();
				} else if (data is IZipFile) {
					zipFile = (data as IZipFile);
					_parser.parse(zipFile.getContentAsString(), _parserTicket, null, null, zipFile.filename);
					zipFile.dispose();
				}
			}
			if (data) {
				_logger.pushMessage("[SIRIUS] Total of " + _toParseData.length + " files initialized");
			}
			
			_toParseData = [];
			
			_syncLoader.signals.FILE_LOADED.release(_onSyncFileLoaded);
			_syncLoader.signals.LOAD_COMPLETE.release(_onSyncLoadComplete);
			
			_signals.COMPLETE.send(ResourceSignal, false);
		}
		
		
		public function ModLoader(extension:*) {
			_extension = extension;
			_toParseData = [];
			_scannedMods = new Vector.<String>();
			_mods = new Dictionary(true);
			_cache = new AssetCache();
			_config = new StartupData(this);
			_syncLoader = new SequentialLoader();
			_signals = new ResourceSignals(this);
			_asyncAssetFileLoad = new Dictionary(true);
			_syncLoader.signals.FILE_LOADED.hold(_onSyncFileLoaded);
			_syncLoader.signals.LOAD_COMPLETE.hold(_onSyncLoadComplete);
			_syncLoader.signals.LOAD_PROGRESS.hold(_onSyncProgress);
			_parsedFileCount = 0;
			_parser = new SruDecoder(false);
			_parser.signals.ERROR.hold(function(e:SruErrorSignal):void {
					_logger.pushError(e.message);
				});
		}
		
		private function _onSyncProgress(signal:LoaderSignal):void {
			_signals.ON_PROGRESS.send(ResourceSignal, true, signal.file, signal.loader.loadCicleProgress);
		}
		
		
		private function _onSyncLoadComplete(signal:LoaderSignal):void {
			switch (_loadPhase) {
				case STARTUP_DATA:  {
					_loadPhase = MOD_DATA;
					var mod:Mod;
					_config.loadorder.iterate(function(name:String, enabled:Boolean):void {
							mod = _mods[name];
							if (enabled && mod) {
								_logger.pushMessage("[LOAD] Mod @" + name + " enabled=TRUE");
								_scanMod(mod);
							} else if (!mod) {
								_logger.pushWarning("[LOAD] Mod @" + name + " not found.");
							} else if (!enabled) {
								_logger.pushMessage("[LOAD] Mod @" + name + " enabled=FALSE");
							}
						});
					for each (var id:String in _config.loadorder.unlisted) {
						// List disabled mods
						mod = _mods[id];
						if (!mod) {
							_logger.pushWarning("[LOAD] Mod @" + id + " can't be loaded. Wrong NAME or inexistent");
						}
					}
					_context = new LoaderContext(false, ApplicationDomain.currentDomain, null);
					_context.allowLoadBytesCodeExecution = true;
					_context.allowCodeImport = true;
					_context.imageDecodingPolicy = ImageDecodingPolicy.ON_DEMAND;
					_logger.pushMessage("[LOAD] Loading resource files...");
					_syncLoader.start(_context);
					break;
				}
				case MOD_DATA:  {
					_loadPhase = RESOLVE_DATA;
					_checkResourcesCompletion();
					break;
				}
			}
		
		}
		
		
		private function _register(id:String, version:String, ... dependencies:Array):Mod {
			var mod:Mod = _mods[id];
			if (mod) {
				if (mod.compare(version, dependencies, _path)) {
					_logger.pushWarning("Mod [" + id + "] already registered. Game will use the version [" + version + "]");
				} else {
					_logger.pushError("Mod [" + id + "] already registered.");
				}
			} else {
				mod = new Mod(id, version, dependencies, _path, _cache);
				_mods[id] = mod;
				_config.loadorder.register(mod);
			}
			_current = mod;
			mod.compressed = _compressedMod;
			return mod;
		}
		
		
		public function start(skipDomains:Array, desktop:Boolean, parameters:Object):ModLoader {
			_shared = parameters;
			_loadPhase = 0;
			_createTicket();
			_cache.avoidDomains(skipDomains);
			_IS_DESKTOP = desktop;
			_logger.pushMessage("[LOAD] " + (_IS_DESKTOP ? "DESKTOP" : "MOBILE") + " MODE ENABLED");
			if (_IS_DESKTOP){
				_preScan();
			}else{
				
			}
			return this;
		}
		
		
		private function _createTicket():void {
			_parserTicket = {
				mod: {
					name: _register, 
					author: function(... str:Array):void {
						_current.setAuthor(str.join(" "));
					}, 
					description: function(... str:Array):void {
						_current.setDescription(str.join(" "));
					}, 
					onload: function(... str:Array):void {
						_current.onload = str.join("");
						if (_current.onload == 'null' || _current.onload.length == 0){
							_current.onload = null;
						}
					}
				}, 
				core: _extension, 
				properties: _config.properties
			};
		}
		
		
		public function getMod(id:String):Mod {
			return _mods[id];
		}
		
		
		public function parse(content:String, name:String):void {
			_parser.parse(content, _parserTicket, null, _sruParserError, name);
		}
		
		
		public function get cache():AssetCache {
			return _cache;
		}
		
		
		public function get mod():Mod {
			return _current;
		}
		
		
		public function get signals():ResourceSignals {
			return _signals;
		}
		
		
		public function get config():StartupData {
			return _config;
		}
		
		public function get progress():Number {
			return _parsedFileCount / _syncLoader.length;
		}
	
	}

}