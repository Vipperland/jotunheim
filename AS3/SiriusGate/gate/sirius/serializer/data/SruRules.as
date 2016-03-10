package gate.sirius.serializer.data {
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruRules {
		
		private var _chart:Object;
		
		private var _isDisabled:Boolean;
		
		public var sortMode:uint = 0;
		
		public function SruRules() {
			_chart = {};
		}
		
		public function allow(param:String):void {
			_chart[param] = 1;
		}
		
		public function enable():void {
			_isDisabled = false;
		}
		
		public function disable():void {
			_isDisabled = true;
		}
		
		public function hide(param:String):void {
			delete _chart[param];
		}
		
		public function isVisible(param:String):Boolean {
			return _isDisabled || !_chart[param];
		}
		
		public function get isDisabled():Boolean {
			return _isDisabled;
		}
	
	}

}