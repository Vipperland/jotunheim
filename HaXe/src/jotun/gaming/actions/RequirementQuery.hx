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
	
	private function _resolve(a:Dynamic, r:String, v:Dynamic):Bool {
		if (r == null) {
			r = ">=";
		}
		switch(r){
			case "=" : return a == v;
			case "!=" : return a != v;
			case "<" : return a < v;
			case "<=" : return a <= v;
			case ">" : return a > v;
			case ">=" : return a >= v;
			case "&" : return (a & v) == v;
			case "!&" : return (~a & v) == v;
			case "*=" : return a.indexOf(v) != -1;
			case "~=" : return v.indexOf(a) != -1;
			// Random check
			case "#=" : return Std.int(Math.random() * a) == v;
			case "#!" : return Std.int(Math.random() * a) != v;
			case "#>" : return Std.int(Math.random() * a) >= v;
			case "#<" : return Std.int(Math.random() * a) <= v;
			default : return a == v;
		}
	}
	
	public function new() {
		super();
	}
	
}