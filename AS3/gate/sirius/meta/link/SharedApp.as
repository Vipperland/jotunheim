package gate.sirius.meta.link {
	
	import flash.display.Sprite;
	import gate.sirius.meta.link.controller.ISharedBridge;
	import gate.sirius.meta.link.controller.LinkResult;
	import gate.sirius.meta.link.controller.SharedBridge;
	import gate.sirius.meta.link.errors.SharedAppError;
	
	import flash.utils.Dictionary;
	
	
	/**
	 * ...
	 * @author Rafael Moreira (GateOfSirius)
	 */
	public class SharedApp extends Sprite implements ISharedApp {
		
		static private var _LOAD_COUNT:int = 0;
		
		static private const _LOADED_APPS:Dictionary = new Dictionary(true);
		
		private var _appid:String;
		
		private var _bridge:ISharedBridge;
		
		private var _version:int;
		
		private var _dependencies:Array;
		
		
		static public function hasApplication(name:String, version:int):void {
		
		}
		
		
		public function SharedApp(appid:String = null, version:int = 1, ... dependencies:Array) {
			_appid = appid;
			_version = version;
			_dependencies = dependencies;
			_bridge = new SharedBridge(this);
		}
		
		
		/* INTERFACE alchemy.vipperland.sirius.link.ISharedApp */
		
		public function checkApplication():LinkResult {
			var errors:Vector.<SharedAppError> = new Vector.<SharedAppError>();
			var tmp:String = _appid;
			for each (var dname:String in _dependencies) {
				var info:Array = dname.split(",");
				dname = info[0];
				var dapp:Vector.<ISharedApp> = _LOADED_APPS[dname];
				if (!dapp || dapp.length == 0) {
					errors[errors.length] = new SharedAppError(this, "Dependency " + dname + " not found for " + _appid, 10001);
					continue;
				}
				var dversion:int = info[1];
				var fversion:Boolean = false;
				for each (var app:ISharedApp in dapp) {
					if (app.version >= dversion) {
						fversion = true;
						break;
					}
				}
				if (!fversion) {
					errors[errors.length] = new SharedAppError(this, "Dependency " + dname + "found, but " + _appid + " requires version " + dversion + ".", 10002);
				}
			}
			if (errors.length == 0) {
				(_LOADED_APPS[_appid] ||= new Vector.<ISharedApp>()).push(this);
				_bridge.loadMemory();
			}
			return new LinkResult(errors);
		}
		
		
		public function unloadApplication():void {
			_bridge.unloadMemory();
		}
		
		
		public function get appid():String {
			return _appid;
		}
		
		
		public function get version():int {
			return _version;
		}
		
		
		public function get bridge():ISharedBridge {
			return _bridge;
		}
	
	}

}