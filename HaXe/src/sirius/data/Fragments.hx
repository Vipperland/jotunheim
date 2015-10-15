package sirius.data;
import sirius.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class Fragments implements IFragments {

	public var value:String;
	
	public var pieces:Array<String>;
	
	public var first:String;
	
	public var last:String;
	
	public function new(value:String, ?separator:String) {
		this.value = value == null ? "" : value;
		if (separator != null && separator.length > 0) split(separator);
	}
	
	public function split(separator:String):IFragments {
		pieces = Utils.clearArray(value.split(separator));
		first = pieces[0];
		last = pieces[pieces.length-1];
		glue(value);
		return this;
	}
	
	public function glue(value:String):IFragments {
		this.value = pieces.join(value);
		return this;
	}
	
	public function addPiece(value:String, ?at:Int = -1):IFragments {
		if (at == 0) pieces.unshift(value);
		else if (at == -1 || at >= pieces.length) pieces.push(value);
		else {
			var tail:Array<String> = pieces.splice(at, pieces.length - at);
			pieces.push(value);
			pieces = pieces.concat(tail);
		}
		return this;
	}
	
	public function get(i:Int):String {
		return i < pieces.length ? pieces[i] : "";
	}
	
	public function clear():IFragments {
		pieces = [];
		first = "";
		last = "";
		return this;
	}
	
}