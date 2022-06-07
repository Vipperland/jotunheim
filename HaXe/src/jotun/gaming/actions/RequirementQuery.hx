package jotun.gaming.actions;
import jotun.objects.Query;
import jotun.tools.Utils;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_RequirementQuery")
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
		return switch(r){
			// if a is equal b
			case "=","equal" : a == v;
			// if a is different of b
			case "!=","diff" : a != v;
			// if a lesser than v
			case "<","less" : a < v;
			// if a lesser than or equal v
			case "<=","lessor" : a <= v;
			// if a greater than v
			case ">","great": a > v;
			// if a greater than or equal v
			case ">=","greator" : a >= v;
			// if a contain bit v
			case "&","test" : (a & v) == v;
			// if a don't contain bit v
			case "!&","not": (~a & v) == v;
			// if a contain b
			case "*=","contain" : a.indexOf(v) != -1;
			// if b contain a
			case "~=","in" : v.indexOf(a) != -1;
			// if random * a is equal b
			case "#=","random" : Std.int(rng() * a) == (v >> 0);
			// if random * a is different b
			case "#!","rngnot" : Std.int(rng() * a) != (v >> 0);
			// if random * a greater then or equal  b
			case "#>","rnggreat" : (rng() * a) >= v;
			// if random * a lesser then or equal  b
			case "#<","rngless" : (rng() * a) <= v;
			// if a is equal b
			default : a == v;
		}
	}
	
	public var ioContext:IEventContext;
	
	public function new() {
		super();
	}
	
}