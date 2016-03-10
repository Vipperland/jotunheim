package gate.sirius.file.zip.swc {
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import gate.sirius.file.FileType;
	import gate.sirius.file.SequentialLoader;
	import gate.sirius.file.zip.IZip;
	import gate.sirius.file.zip.IZipFile;
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SWCParser implements ISWCParser {
		
		protected var _onComplete:Function;
		
		protected var _libraryByPath:Dictionary;
		
		protected var _parsedClasses:Dictionary;
		
		protected var _loader:SequentialLoader;
		
		protected var _error:String;
		
		
		public function addSWC(zip:IZip, onComplete:Function = null):void {
			
			_onComplete = onComplete;
			
			var f:IZipFile = zip.getFileByName("catalog.xml");
			
			if (!f) {
				throw new Error("Invalid SWC file.");
			}
			
			var swcCatalog:XMLList = new XML(f.getContentAsString()).children();
			
			var swfList:Vector.<String> = new Vector.<String>();
			
			try {
				
				for each (var mainNode:XML in swcCatalog) {
					if (mainNode.name().localName == "libraries") {
						for each (var node:XML in mainNode.children()) {
							if (node.name().localName == "library") {
								var path:String = node.@path;
								_libraryByPath[path] = new Vector.<String>();
								_loader.addFile(path, zip.getFileByName(node.@path).content, FileType.BINARY);
								for each (var classNode:XML in node.children()) {
									_libraryByPath[path].push(classNode.@name);
								}
							}
						}
						break;
					}
				}
				
			} catch (e:Error) {
				
				_error = e.getStackTrace();
				if (onComplete !== null)
					onComplete(this as ISWCParser);
				return;
				
			}
			
			_loader.start();
		
		}
		
		
		public function SWCParser() {
			
			_loader = new SequentialLoader();
			
			_libraryByPath = new Dictionary(true);
			
			_parsedClasses = new Dictionary(true);
			
			_loader.onFileLoaded = _parseClass;
			
			_loader.onComplete = _close;
		
		}
		
		
		protected function _close(loader:SequentialLoader):void {
			if (onComplete !== null)
				onComplete(this as ISWCParser);
		}
		
		
		protected function _parseClass(loader:SequentialLoader):void {
			
			if (!loader.currentFile.content) {
				delete _libraryByPath[loader.currentFile.name];
				return;
			}
			
			var classNames:Vector.<String> = _libraryByPath[loader.currentFile.name];
			
			var C:Class;
			
			var appDomain:ApplicationDomain;
			
			var validClasses:Vector.<String> = new Vector.<String>();
			
			for each (var name:String in classNames) {
				
				appDomain = (loader.currentFile.content.loaderInfo.applicationDomain as ApplicationDomain);
				
				if (appDomain.hasDefinition(name)) {
					C = appDomain.getDefinition(name) as Class;
					validClasses[validClasses.length] = name;
					_parsedClasses[name] = C;
				}
				
			}
			
			_libraryByPath[loader.currentFile.name] = validClasses;
		
		}
		
		
		public function getClass(name:String):Class {
			return _parsedClasses[name];
		}
		
		
		public function getInstanceOf(className:String):* {
			var C:Class = getClass(className);
			if (C !== null)
				return new C();
			return null;
		}
		
		
		public function findClassNames():Vector.<String> {
			var names:Vector.<String> = new Vector.<String>();
			for each (var validNames:Vector.<String>in _libraryByPath) {
				names = names.concat(validNames);
			}
			return names;
		}
		
		
		public function get onComplete():Function {
			return _onComplete;
		}
		
		
		public function set onComplete(value:Function):void {
			_onComplete = value;
		}
		
		
		public function get error():String {
			return _error;
		}
	
	}

}