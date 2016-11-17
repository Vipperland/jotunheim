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
	
	private function _sel(i:Int, e:Int):String {
		var r:Array<String> = [];
			while (i != e)  {
			var p:String = pieces[i++];
			if(p != null && p != '')
				r[r.length] = p;
		}
		return "/" + r.join("/") + "/";
	}
	
	public function new(value:String, ?separator:String) {
		this.value = value == null ? "" : value;
		if (separator != null && separator.length > 0) split(separator);
		else clear();
	}
	
	public function split(separator:String):IFragments {
		pieces = Utils.clearArray(value.split(separator));
		if (pieces.length == 0) pieces[0] = "";
		first = pieces[0];
		last = pieces[pieces.length - 1];
		glue(separator);
		return this;
	}
	
	public function find(value:String):Bool {
		return Lambda.indexOf(pieces, value) != -1;
	}
	
	public function glue(value:String):IFragments {
		this.value = pieces.join(value);
		return this;
	}
	
	public function addPiece(value:String, ?at:Int = -1):IFragments {
		if (at == 0)
			pieces.unshift(value);
		else if (at == -1 || at >= pieces.length)
			pieces.push(value);
		else {
			var tail:Array<String> = pieces.splice(at, pieces.length - at);
			pieces.push(value);
			pieces = pieces.concat(tail);
		}
		return this;
	}
	
	public function get(i:Int, ?e:Int):String {
		return e == null || e <= i ? (i < pieces.length ? pieces[i] : "") : _sel(i, e);
	}
	
	public function set(i:Int, val:String):IFragments {
		if (i > pieces.length) i = pieces.length;
		if (val != null)
			pieces[i] = val;
		return this;
	}
	
	public function clear():IFragments {
		pieces = [];
		first = "";
		last = "";
		return this;
	}
	
}