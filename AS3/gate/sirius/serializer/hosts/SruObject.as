package gate.sirius.serializer.hosts {
	
	import gate.sirius.serializer.data.SruRules;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public dynamic class SruObject implements IList, IStartable, IRules {
		
		protected var _length:uint = 0;
		
		protected var _rules:SruRules;
		
		public function SruObject() {
		
		}
		
		public function search(value:*):String {
			var param:String;
			for (param in this)
				if (this[param] == value)
					break;
			return param;
		}
		
		/* INTERFACE gate.sirius.serializer.hosts.IList */
		
		public function push(value:*):uint {
			this[_length] = value;
			return ++_length;
		}
		
		public function get length():uint {
			return _length;
		}
		
		/* INTERFACE gate.sirius.serializer.hosts.IRules */
		
		public function get rules():SruRules {
			return _rules;
		}
		
		/* INTERFACE gate.sirius.serializer.hosts.IStartable */
		
		public function onParseOpen():void {
		}
		
		public function onParseClose():void {
		}
	
	}

}