package gate.sirius.isometric.recycler {
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Recycler {
		
		private var _junk:Dictionary;
		
		private var _type:String;
		
		private var _object:IRecyclable;
		
		
		public function Recycler() {
			_junk = new Dictionary(true);
		}
		
		
		public function dump(object:IRecyclable, type:Class):void {
			object.onDump();
			var target:Vector.<IRecyclable> = _junk[type] ||= new Vector.<IRecyclable>;
			target[target.length] = object;
		}
		
		
		public function collect(Type:Class, ifEmpty:Function = null):* {
			var target:Vector.<IRecyclable> = _junk[Type] ||= new Vector.<IRecyclable>;
			if (target.length > 0) {
				return target.pop();
			}
			_object = Function(ifEmpty || _create)(Type);
			_object.onCollect();
			return _object;
		}
		
		
		public function discart(Type:Class):void {
			delete _junk[Type];
		}
		
		
		protected function _create(Type:Class):IRecyclable {
			return new Type();
		}
		
		
		public function lengthOf(Type:Class):int {
			return (_junk[Type] ||= new Vector.<IRecyclable>).length;
		}
	
	}

}