package gate.sirius.isometric.behaviours {
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class Behaviours {
		
		internal var _targetOrigin:Object;
		
		public function Behaviours(origin:Object = null) {
			_targetOrigin = origin;
		}
		
		
		public function setOrigin(target:Object):void {
			_targetOrigin = target;
		}
		
		
		public function get targetOrigin():Object {
			return _targetOrigin;
		}
		
		
		public function clone():Behaviours {
			return new Behaviours(_targetOrigin);
		}
		
		
		public function toString():String {
			return "[Behaviours targetOrigin=" + getQualifiedClassName(targetOrigin) + "]";
		}
	
	}

}