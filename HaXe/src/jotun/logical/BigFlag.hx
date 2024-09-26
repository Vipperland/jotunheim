package jotun.logical;
import jotun.errors.Error;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("Jtn.BigFlag")
class BigFlag {

	static public function fromString(value:String):BigFlag {
		return (new BigFlag(value.length)).flush(value, 0);
	}
	
	private var _parts:Array<Flag>;
	
	private var _length:Int;
	
	private function _build(length:Int) {
		_length = length;
		var i:Int = _parts.length;
		var t:Int = Math.ceil(_length / 32);
		while(i < t){
			_parts[i] = new Flag(0);
			++i;
		}
	}
	
	private function _bit(bit:Int):Int {
		while(bit > 31){
			bit -= 32;
		}
		return bit;
	}
	
	private function _get(i:Int):Flag {
		i = Std.int(i / 32);
		return _parts[i];
	}
	
	public function new(length:Int) {
		_parts = [];
		_build(length);
	}
	
	public function set(bit:Int, value:Bool):BigFlag {
		if(value){
			_get(bit).put(_bit(bit));
		}else{
			_get(bit).drop(_bit(bit));
		}
		return this;
	}
	
	public function put(bit:Int):BigFlag {
		_get(bit).put(_bit(bit));
		return this;
	}
	
	public function drop(bit:Int):BigFlag {
		_get(bit).drop(_bit(bit));
		return this;
	}
	
	public function toggle(bit:Int):BigFlag {
		_get(bit).toggle(_bit(bit));
		return this;
	}
	
	public function test(bit:Int):Bool {
		return _get(bit).test(_bit(bit));
	}
	
	public function part(index:Int):Flag {
		return _parts[index];
	}
	
	public function expand(length:Int):BigFlag {
		_build(length);
		return this;
	}
	
	public function flush(value:String, offset:Int = 0):BigFlag {
		var f:Int = _bit(offset);
		var o:Int = value.length;
		while (o-- > 0){
			var p:Int = Std.int(o + offset);
			_get(p).set(f, value.substr(o, 1) == '1');
			if(++f > 31){
				f -= 32;
			}
		}
		return this;
	}
	
	public function toString(glen:Int = 8):String {
		var r:Array<String> = [];
		Dice.Values(_parts, function(v:Flag):Void {
			r.push(v.toString(32, glen));
		});
		return r.join(' ');
	}
	
	public function toCard(glen:Int = 8):String {
		var r:Array<String> = [];
		Dice.Values(_parts, function(v:Flag):Void {
			r.push(v.toString(32, glen));
		});
		return r.join('\r\n');
	}
	
	
	
}