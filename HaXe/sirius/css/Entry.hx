package sirius.css;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Entry {
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
	
	public function new(keys:Array<IKey>, dict:Dynamic) {
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
			Dice.Values(keys, function(v:IKey) {
				next = keys[++c];
				r += v.entry != null ? v.entry.verifier(this, v, next) : _valueOf(v);
				return canceled;
			});
		}
		// If all keys if missing, return NULL
		return missing == keys.length ? null : r;
	}
	
	public function cancel():Void {
		canceled = true;
	}
	
	private function _valueOf(v:IKey):String {
		if (v.color != null) return v.color;
		if (v.measure != null) return v.measure;
		++missing;
		return v.key;
	}
}
