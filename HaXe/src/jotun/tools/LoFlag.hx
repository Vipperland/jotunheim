package jotun.tools;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class LoFlag {
	
	public static function fromString(value:String):LoFlag {
		return (new LoFlag(0)).load(value);
	}
	
	public static function fromVect(data:Array<Int>):LoFlag {
		var f:LoFlag = new LoFlag(0);
		f._flags = data;
		return f;
	}
	
	private var _flags:Array<Int>;
	
	private function _fit(length:Int):Void {
		while (_flags.length < length){
			_flags[_flags.length] = 0;
		}
	}
	
	public function new(?size:Int=32):Void {
		_flags = [];
		if (--size > 0){
			_fit(Math.ceil(size / 32));
		}
	}
	
	public function load(data:Dynamic):LoFlag {
		if(Std.isOfType(data, String)){
			Dice.All(data.split('-'), function(p:Int, v:String){
				_flags[_flags.length] = Std.parseInt(v);
			});
		}else if (Std.isOfType(data, Array)){
			_flags = data;
		}
		return this;
	}
	
	public function set(block:Int, flags:Int):LoFlag {
		_flags[block] = flags;
		return this;
	}
	
	public function put(i:Int):LoFlag {
		var b:Int = Std.int(i / 32);
		var o:Int =_flags[b] | (1<<(i%32));
		return this;
	}
	
	public function drop(i:Int):LoFlag {
		var b:Int = Std.int(i / 32);
		var o:Int =_flags[b] | ~(1<<(i%32));
		return this;
	}
	
	public function get(i:Int):Bool {
		var b:Int = Std.int(i / 32);
		i = (1 << (i % 32));
		return ((_flags[b])&i)==i;
	}
	
	public function flags():Array<Int> {
		return _flags;
	}
	
	public function toString():String {
		return _flags.join('-');
	}
	
}