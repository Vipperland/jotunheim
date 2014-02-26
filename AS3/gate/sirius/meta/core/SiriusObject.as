package gate.sirius.meta.core {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public dynamic class SiriusObject extends Object {
		
		private var _length:int;
		
		private var _indexed:Boolean;
		
		
		public function SiriusObject() {
		}
		
		
		public function get length():int {
			
			return _length;
		
		}
		
		
		public function isIndexed():Boolean {
			return _indexed;
		}
		
		
		public function setIndexedMode(value:Boolean):void {
			_indexed = value;
		}
		
		
		public function push(value:*):void {
			this[length] = value;
			++_length;
		}
		
		
		public function indexOf(value:*):* {
			for (var i:String in this) {
				if (this[i] == value) {
					return i;
				}
			}
			return -1;
		}
		
		
		public function remove(param:*):* {
			var value:* = this[param];
			delete this[param];
			return value;
		}
		
		
		public function toArray():* {
			
			var r:Array = new Array();
			
			for (var param:*in this)
				r[r.length] = this[param];
			
			return r;
		
		}
	
	}

}