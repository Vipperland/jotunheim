package jotun.gaming.actions;
import jotun.objects.Query;
import jotun.tools.Utils;

/**
 * ...
 * @author Rim Project
 */
@:expose("jtn.game.RequirementQuery")
class RequirementQuery extends Query {
	
	private function _isempty(value:String):Bool {
		return value == null || value == "";
	}
	
	private function _INT(value:String):Int {
		var o:Int = Std.parseInt(value);
		return o != null ? o : 0;
	}
	
	private function _FLOAT(value:String):Float {
		var o:Float = Std.parseFloat(value);
		return o != null ? o : 0;
	}
	
	public function rng():Float {
		return Math.random();
	}
	
	private function _resolve(a:Dynamic, r:String, v:Dynamic):Bool {
		if (r == null) {
			r = ">=";
		}
		switch(r){
			// if a is equal b
			case "=" : return a == v;
			// if a is different of b
			case "!=" : return a != v;
			// if a lesser than v
			case "<" : return a < v;
			// if a lesser than or equal v
			case "<=" : return a <= v;
			// if a greater than v
			case ">" : return a > v;
			// if a greater than or equal v
			case ">=" : return a >= v;
			// if a contain bit v
			case "&" : return (a & v) == v;
			// if a don't contain bit v
			case "!&" : return (~a & v) == v;
			// if a contain b
			case "*=" : return a.indexOf(v) != -1;
			// if b contain a
			case "~=" : return v.indexOf(a) != -1;
			// if random * a is equal b
			case "#=" : return Std.int(rng() * a) == (v >> 0);
			// if random * a is different b
			case "#!" : return Std.int(rng() * a) != (v >> 0);
			// if random * a greater then or equal  b
			case "#>" : return (rng() * a) >= v;
			// if random * a lesser then or equal  b
			case "#<" : return (rng() * a) <= v;
			// if a is equal b
			default : return a == v;
		}
	}
	
	public function new() {
		super();
	}
	
}