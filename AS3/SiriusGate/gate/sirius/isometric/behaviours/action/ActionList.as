package gate.sirius.isometric.behaviours.action {
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import gate.sirius.isometric.behaviours.core.ICoreElement;
	import gate.sirius.isometric.behaviours.core.ICoreList;
	import gate.sirius.log.ULog;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ActionList implements ICoreList {
		
		private static const _AVAILABLE:Dictionary = new Dictionary(true);
		
		private static const _INSTANCES:Dictionary = new Dictionary(true);
		
		
		public static function create(id:String, definition:String, args:Array):ICoreElement {
			definition = definition.toLowerCase();
			var token:Token = _AVAILABLE[definition] as Token;
			if (!token) {
				ULog.GATE.pushWarning("CoreList::" + id + "[" + definition + "] definition is missing, can't create object");
				return null;
			}
			try {
				var ObjectClass:Class = token.c;
				var object:ICoreElement = new ObjectClass(id) as BasicAction;
				object.construct.apply(object, args);
				_INSTANCES[id] = object;
			} catch (e:Error) {
				ULog.GATE.pushError("CoreList::" + id + "[" + definition + "].construct() call failed.\n" + e.getStackTrace());
			}
			
			
			return object;
		}
		
		
		private function _checkOverride(id:String, type:Class):void {
			if (_INSTANCES[id]) {
				ULog.GATE.pushWarning("CoreList::[" + id + "]. " + getQualifiedClassName(_INSTANCES[id]) + " overrided by " + getQualifiedClassName(type));
			}
		}
		
		
		public function ActionList() {
		}
		
		
		public function register(id:String, type:Class, help:String):void {
			id = id.toLowerCase();
			_checkOverride(id, type);
			_AVAILABLE[id] = new Token(type, help);
		}
		
		
		public function create(id:String, definition:String, ... args:Array):ICoreElement {
			return create(id, definition, args);
		}
		
		public function help(type:String):String {
			var token:Token = (_AVAILABLE[type] as Token);
			if (token) {
				ULog.GATE.pushMessage(type + " usage:" + token.h);
			}
			return token.h;
		}
	
	}

}


class Token {
	
	public var c:Class;
	
	public var h:String;
	
	
	public function Token(c:Class, h:String) {
		this.c = c;
		this.h = h;
	}
}