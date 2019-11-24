package jotun.tools;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class LoFlag {
	
	public static function fromString(value:String):LoFlag {
		return (new LoFlag(0)).load(value)
	}
	
	public static function fromVect(data:Array<Int>):LoFlag {
		var f:LoFlag = new LoFlag(0);
		f._flags = data;
		return f;
	}
	
	private var _flags:Array<Int>;
	
	public function new(?size:Int=0):Void {
		_flags = [];
		if(size > 0){
			while (_flags.length < size){
				_flags[_flags.length] = 0;
			}
		}
	}
	
	public function load(data:String):LoFlag {
		Dice.All(data.split('-'), function(p:Int, v:String){
			_flags[_flags.length] = Std.parseInt(v);
		});
	}
	
	public function set(block:Int, flags:Int):LoFlag {
		while (_flags.length < block){
			_flags[_flags.length] = 0;
		}
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
	
	public function toString():String {
		return _flags.join('-');
	}
	
}