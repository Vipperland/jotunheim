package jotun.signals;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
@:expose("Jtn.Signal")
class Signals {
	
	private var _l:Array<Dynamic>;
	
	public var object:Dynamic;
	
	private function _c(n:String):Pipe {
		if (!has(n)) 
			Reflect.setField(_l, n, new Pipe(n, this));
		return Reflect.field(_l, n);
	}
	
	public function new(to:Dynamic) {
		object = to;
		reset();
	}
	
	public function has(name:String):Bool {
		return Reflect.hasField(_l, name);
	}
	
	public function get(name:String):Pipe {
		return _c(name);
	}
	
	public function remove(name:String, ?handler:Flow->Void):Pipe {
		return _c(name).remove(handler);
	}
	
	public function add(name:String, ?handler:Flow->Void):Pipe {
		return _c(name).add(handler);
	}
	
	public function call(name:String, ?data:Dynamic):Signals {
		if (has(name)) 
			get(name).call(data);
		return this;
	}
	
	public function reset(?name:String):Void {
		if (name != null){
			if (has(name))
				get(name).reset();
		}else{
			_l = [];
		}
	}
	
}