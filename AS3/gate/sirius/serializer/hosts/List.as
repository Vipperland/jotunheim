package gate.sirius.serializer.hosts {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public dynamic class List implements IList {
		
		private var _length:uint;
		
		public function List() {
		
		}
		
		/* INTERFACE gate.sirius.serializer.hosts.IList */
		
		public function get length():uint {
			return _length;
		}
		
		public function push(value:*):uint {
			this[_length] = value;
			++_length;
		}
		
		public function indexOf(value:*):* {
			for (var i:uint = 0; i < _length; ++i) {
				if (this[i] == value) {
					return i;
				}
			}
			return -1;
		}
		
		public function positionOf(value:*):* {
			for (var v:*in this) {
				if (this[v] == value) {
					return v;
				}
			}
			return null;
		}
		
		public function remove(index:uint, organize:Boolean = false):void {
			if (index in this) {
				delete this[index];
				if (organize && index < _length - 1 && _length > 1) {
					--_length;
					for (index; index < _length; ++index) {
						this[index] = this[index + 1];
					}
					delete this[index];
				}
			}
		}
	
	}

}