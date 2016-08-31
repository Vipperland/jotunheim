package sirius.css;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Entry {
	
	// if class is important
	public var important:Bool;
	// All pieces of class
	public var keys:Array<IKey>;
	// First valid piece
	public var head:IKey;
	// Last valid piece
	public var tail:IKey;
	// Next piece value
	public var next:IKey;
	// Total missing keys
	public var missing:Int;
	// If parser is canceled (ignore pendent keys)
	public var canceled:Bool;
	
	public function new(keys:Array<IKey>, dict:Dynamic,i:Bool) {
		this.important = i;
		this.keys = keys;
		this.head = keys[0];
		this.tail = keys[keys.length - 1];
		this.missing = 0;
		this.canceled = false;
	}
	public function build():String {
		var r:String = null;
		if (head != null) {
			r = "";
			var c:Int = 0;
			var t:Int = keys.length;
			Dice.Values(keys, function(v:IKey) {
				if(!v.skip){
					next = keys[++c];
					r += v.entry != null ? v.entry.verifier(this, v, next) : _valueOf(v, t, c);
				}
				return canceled;
			});
		}
		// If all keys if missing, return NULL
		return r + (important ? ' !important' : '');
	}
	
	public function cancel():Void {
		canceled = true;
	}
	
	private function _valueOf(v:IKey, t:Int, c:Int):String {
		if (v.color != null) return v.color;
		if (v.measure != null) return v.measure;
		++missing;
		return v.key + (t==c ? "" : t-1==c ? ":" : "-");
	}
	
	public function get(i:Int):IKey {
		return i < keys.length ? keys[i] : null;
	}
	
	public function hasKey(s:String, i:Int, ?e:Int):Bool {
		if (e == null) e = keys.length;
		return !Dice.Count(i, e, function(a:Int, b:Int, c:Bool) {return keys[a].key == s;}).completed;
	}
	
	public function compile(s:Int, ?e:Int):Array<String> {
		var r:Array<String> = [];
		if (e == null) e = keys.length;
		Dice.Count(s, e, function(a:Int, b:Int, c:Bool) {
			r[r.length] = keys[a].key;
			return false;
		});
		return r;
	}
}
