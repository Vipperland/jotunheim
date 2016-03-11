package gate.sirius.isometric.recycler {
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Recycler {
		
		static public const GATE:Recycler = new Recycler();
		
		private var _junk:Dictionary;
		
		private var _type:String;
		
		private var _object:IRecyclable;
		
		private var _ticket:RecycledObject;
		
		public function Recycler() {
			_junk = new Dictionary(true);
			_ticket = new RecycledObject();
		}
		
		public function dump(object:IRecyclable):void {
			object.recyclerDump();
			var cname:String = getQualifiedClassName(object);
			var target:Vector.<IRecyclable> = _junk[cname] ||= new Vector.<IRecyclable>;
			target[target.length] = object;
		}
		
		public function collect(Type:Class, ... props:Array):IRecycledObject {
			var cname:String = getQualifiedClassName(Type);
			var target:Vector.<IRecyclable> = _junk[cname] ||= new Vector.<IRecyclable>;
			if (target.length > 0) {
				var object:IRecyclable = target.pop();
				object.recyclerCollect.apply(object, props);
				return _ticket.put(object);
			}
			var len:uint = props.length;
			if (len > 7) {
				_object = new Type(props);
			}else {
				switch (len) {
					case 0: 
						_object = new Type();
						break;
					case 1: 
						_object = new Type(props[0]);
						break;
					case 2: 
						_object = new Type(props[0], props[1]);
						break;
					case 3: 
						_object = new Type(props[0], props[1], props[2]);
						break;
					case 4: 
						_object = new Type(props[0], props[1], props[2], props[3]);
						break;
					case 5: 
						_object = new Type(props[0], props[1], props[2], props[3], props[4]);
						break;
					case 6: 
						_object = new Type(props[0], props[1], props[2], props[3], props[4], props[5]);
						break;
					case 7: 
						_object = new Type(props[0], props[1], props[2], props[3], props[4], props[5], props[6]);
						break;
				}
			}
			return _ticket.put(_object);
		}
		
		public function clearTrash():void {
			for (var T:*in _junk) 
				delete _junk[T];
		}
		
		public function discartAllOf(Type:Class):void {
			delete _junk[getQualifiedClassName(Type)];
		}
		
		public function lengthOf(Type:Class):int {
			return (_junk[getQualifiedClassName(Type)] ||= new Vector.<IRecyclable>).length;
		}
		
		public function filter(handler:Function, discart:Boolean, ... types:Array):void {
			for each (var Type:Class in types) {
				for each (var obj:*in _junk[Type]) 
					handler(obj as Type);
				if (discart) 
					delete _junk[Type];
			}
		}
		
		public function toString():String {
			var result:Array = [];
			var defCount:int = 0;
			var total:int = 0;
			var crCount:int = 0;
			for (var T:*in _junk) {
				++defCount;
				crCount = lengthOf(T);
				total += crCount;
				result[result.length] = "#" + defCount + "	{class:" + getQualifiedClassName(T) + ", length:" + crCount + "}";
			}
			return "[ Recycler.report {difinitions:" + defCount + ", objects:" + total + ", result:[\n	" + result.join(",\n	") + "\n]}]";
		}
	
	}

}