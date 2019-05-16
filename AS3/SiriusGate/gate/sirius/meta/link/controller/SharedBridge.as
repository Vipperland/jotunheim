package gate.sirius.meta.link.controller {
	
	import gate.sirius.utils.Explorer;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import gate.sirius.meta.link.errors.SharedAppError;
	import gate.sirius.meta.link.ISharedApp;
	
	/**
	 * ...
	 * @author Rafael Moreira (GateOfSirius)
	 */
	public class SharedBridge implements ISharedBridge {
		
		private static const _CACHE:Dictionary = new Dictionary(true);
		
		private var _app:ISharedApp;
		
		private var _domain:ApplicationDomain;
		
		private var _classNames:Array;
		
		
		public function SharedBridge(app:ISharedApp) {
			_app = app;
		}
		
		
		/* INTERFACE alchemy.vipperland.sirius.link.controller.ISharedBridge */
		
		public function getClass(name:String):Class {
			return _CACHE[name];
		}
		
		
		public function unloadMemory():void {
			_domain = null;
			(_app as Sprite).loaderInfo.loader.unloadAndStop(true);
			_app = null;
		}
		
		
		public function loadMemory():Vector.<SharedAppError> {
			var errors:Vector.<SharedAppError> = new Vector.<SharedAppError>();
			var loader:LoaderInfo = (_app as Sprite).loaderInfo;
			if (loader) {
				_domain = (_app as Sprite).loaderInfo.applicationDomain;
				_classNames = (new SWFExplorer((_app as Sprite).loaderInfo.bytes)).getDefinitions();
				for each (var name:String in _classNames) {
					if (_CACHE[name]) {
						errors[errors.length] = new SharedAppError(_app, "Definition " + name + " overrided by " + _app.appid, 10003);
					}
					_CACHE[name] = _domain.getDefinition(name);
				}
			}else {
				_classNames = [];
			}
			return errors;
		}
		
		
		public function get classNames():Array {
			return _classNames;
		}
	
	}

}