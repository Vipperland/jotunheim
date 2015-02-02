package gate.sirius.modloader {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
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
		
		private var logger:ULog = ULog.GATE;
		
		private var _extension:*;
		
		private var _toParseData:Array;
		
		
		private function _scan(dir:File):void {
			logger.pushMessage("Scanning Mods directory");
			if (dir.exists) {
				var res_dir:File = dir.resolvePath("resources");
				if (!res_dir.exists) {
					res_dir.createDirectory();
				}
				var config_dir:File = res_dir.resolvePath("data");
				if (!config_dir.exists) {
					config_dir.createDirectory();
				}
				var mods_dir:File = res_dir.resolvePath("mods");
				if (!mods_dir.exists) {
					mods_dir.createDirectory();
				}
				var loader:File = mods_dir.resolvePath("loaderscreen");
				if (!loader.exists) {
					loader.createDirectory();
					_config.createInfoFile(loader.resolvePath("info.sru"), "Loader Screen", "0.0.0", null, null, "UILoaderScreen");
				}
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
				_startupConfig(config_dir);
			} else {
				logger.pushError("[LOAD] Critical: Game instalation directory not found.");
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
			_compressedMod.signals.COMPLETE.hold(_disposeCompressedFile);
			_compressedMod.loadBytes(zipData);
		}
		
		
		private function _disposeCompressedFile(zip:IZip):void {
			zip.dispose();
			_current.compressed == null;
		}
		
		
		private function _onCompressedModFileLoaded(signal:ZipSignal):void {
			var file:IZipFile = signal.file;
			if (file.isDirectory) {
				return;
			} else if (file.filename == "info.sru") {
				_parser.parse(file.getContentAsString(), _config, null, _sruParserError, file.filename);
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
		
		
		private function _startupConfig(config:File):void {
			var configData:String = _config.checkFile(config.resolvePath("config.sru"));
			_parser.parse(configData, _config, null, _sruParserError, "config.sru");
			for each (var file:File in config.getDirectoryListing()) {
				if (file.extension == "sru") {
					_syncLoader.addFile("startup=" + file.name, file.nativePath, FileType.TEXT, {asset: false, data: true, mod: null, skip: true});
				}
			}
			_syncLoader.start();
		}
		
		
		private function _scanMod(mod:Mod):Mod {
			
			var list:Array;
			
			var file:File;
			var dir:File;
			
			if (mod.dependencies.length > 0) {
				for each (var dependency:String in mod.dependencies) {
					if (_scannedMods.indexOf(dependency) == -1) {
						logger.pushWarning("Mod [" + mod.id + "] should be load after [" + dependency + "]");
					} else {
						logger.pushMessage("   Dependency Mod @" + dependency + " found.");
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
					
					switch (cfile.directory) {
						case "assets":  {
							assets[assets.length] = [mod.id + "=" + cfile.filename, cfile.content, FileType.BINARY, {asset: false, data: true, mod: mod}];
							break;
						}
						case "data":  {
							++dataCount;
							_syncLoader.addFile(mod.id + "=" + cfile.filename, cfile.uri, FileType.TEXT, {asset: false, data: true, mod: mod});
							break;
						}
					}
					
				}
				
				for each (var assetFile:Array in assets) {
					++assetsCount;
					_syncLoader.addFile.apply(null, assetFile);
				}
				
				logger.pushMessage("   Getting mod/assets/ files (" + assetsCount + ")");
				logger.pushMessage("   Getting mod/data/ files (" + dataCount + ")");
				
			} else {
				
				var modlocation:File = new File(mod.path);
				
				// data directory
				dir = modlocation.resolvePath("data");
				
				if (!dir.exists) {
					dir.createDirectory();
				}
				list = dir.getDirectoryListing();
				for each (file in list) {
					_syncLoader.addFile(mod.id + "=" + file.name, file.nativePath, FileType.TEXT, {asset: false, data: true, mod: mod});
				}
				logger.pushMessage("   Added mod/data/ files (" + list.length + ")");
				
				// assets directory
				
				dir = modlocation.resolvePath("assets");
				if (!dir.exists) {
					dir.createDirectory();
				}
				
				list = dir.getDirectoryListing();
				for each (file in list) {
					_syncLoader.addFile(mod.id + "=" + file.name, file.nativePath, FileType.BINARY, {asset: true, data: false, mod: mod});
				}
				
				logger.pushMessage("   Added mod/assets/ files (" + list.length + ")");
				
			}
			
			_scannedMods[_scannedMods.length] = mod.id;
			
			return mod;
		}
		
		
		private function _sruParserError(signal:SruErrorSignal):void {
			logger.pushError(signal.message);
		}
		
		
		private function _onSyncFileLoaded(signal:LoaderSignal):void {
			var file:IFileInfo = signal.loader.currentFile;
			var isByteArray:Boolean = file.content is ByteArray;
			if (!isByteArray) {
				logger.pushMessage("   File " + file.name + " added (" + signal.loader.loadedFiles + "/" + signal.loader.length + ")");
			}
			if (_current !== file.extra.mod) {
				_initMod(_current);
				_current = file.extra.mod;
			}
			if (file.error) {
				logger.pushWarning((file.error as IOErrorEvent).text);
			} else if (file.extra.asset) {
				if (file.content is ByteArray) {
					if ((file.content as ByteArray).length > 0) {
						_syncLoader.addFile(file.name, file.content, FileType.AUTO_DETECT, file.extra);
					}
				} else {
					switch (file.extension) {
						case "swf":  {
							_cache.register(file.extra.mod, (file.content as DisplayObject));
							break;
						}
						case "jpg":  {
						}
						case "bmp":  {
						}
						case "png":  {
							_cache.registerImage(file.extra.mod, file.name, (file.content as Bitmap).bitmapData);
							break;
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
			}
			_signals.ON_FILE.send(ResourceSignal, true, file);
			++_parsedFileCount;
		}
		
		
		private function _initMod(mod:Mod):void {
			if (mod) {
				_cache.getInstance(mod.onload);
			}
		}
		
		
		private function _onFileParseComplete(signal:SruDecoderSignal):void {
			++_parsedFileCount;
			_checkResourcesCompletion();
		}
		
		
		private function _checkResourcesCompletion():void {
			if (_parsedFileCount == _syncLoader.length && _syncLoader.isComplete) {
				logger.pushMessage("[LOAD] Mod resources loaded");
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
						logger.pushWarning("[LOAD] Mod dependency [" + dependency + "] is required by [" + mod.id + "]");
						missing[missing.length] = dependency;
					}
				}
			}
			
			for each (var data:*in _toParseData) {
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
				logger.pushMessage("[SIRIUS] Total of " + _toParseData.length + " files initialized");
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
			_parsedFileCount = 0;
			_parser = new SruDecoder(false);
			_parser.signals.ERROR.hold(function(e:SruErrorSignal):void {
					logger.pushError(e.message);
				})
		}
		
		
		private function _onSyncLoadComplete(signal:LoaderSignal):void {
			switch (_loadPhase) {
				case STARTUP_DATA:  {
					_loadPhase = MOD_DATA;
					var mod:Mod;
					_config.loadorder.iterate(function(name:String, enabled:Boolean):void {
							mod = _mods[name];
							if (enabled && mod) {
								logger.pushMessage("[LOAD] Mod @" + name + " enabled=TRUE");
								_scanMod(mod);
							} else if (!mod) {
								logger.pushWarning("[LOAD] Mod @" + name + " not found.");
							} else if (!enabled) {
								logger.pushMessage("[LOAD] Mod @" + name + " enabled=FALSE");
							}
						});
					for each (var id:String in _config.loadorder.unlisted) {
						// List disabled mods
						mod = _mods[id];
						if (!mod) {
							logger.pushWarning("[LOAD] Mod @" + id + " can't be loaded. Wrong NAME or inexistent");
						}
					}
					_context = new LoaderContext(false, ApplicationDomain.currentDomain, null);
					_context.allowCodeImport = true;
					_context.imageDecodingPolicy
					logger.pushMessage("[LOAD] Loading resource files...");
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
					logger.pushWarning("Mod [" + id + "] already registered. Game will use the version [" + version + "]");
				} else {
					logger.pushError("Mod [" + id + "] already registered.");
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
		
		
		public function start(skipDomains:Array):ModLoader {
			_loadPhase = 0;
			_createTicket();
			_cache.avoidDomains(skipDomains);
			_scan(new File(File.applicationDirectory.nativePath));
			return this;
		}
		
		
		private function _createTicket():void {
			_parserTicket = {mod: {name: _register, author: function(... str:Array):void {
						_current.setAuthor(str.join(" "));
					}, description: function(... str:Array):void {
						_current.setDescription(str.join(" "));
					}, onload: function(... str:Array):void {
						_current.onload = str.join("");
					}}, core: _extension, properties: _config.properties};
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
	
	}

}