package jotun.gaming.actions;
import jotun.objects.Query;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_ActionQuery")
class ActionQuery extends Query {

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
	
	private function _resolve(a:Dynamic, r:String, v:Dynamic):Dynamic {
		if (r == null) {
			r = "=";
		}
		switch(r){
			// return v
			case "=" : return v;
			// return a plus v
			case "+" : return a + v;
			// return a minus v
			case "-" : return a - v;
			// return a plus 1
			case "++" : return a + 1;
			// return a minus 1
			case "--" : return a - 1;
			// return a times 1
			case "*" : return a * v;
			// return a divided v
			case "/" : return a / v;
			// return a module v
			case "%" : return a % v;
			// return a shift left
			case "<<" : return a << v;
			// return a shift right
			case ">>" : return a >> v;
			// return a whithout v
			case "~" : return a & ~(v >> 0);
			// return a OR v
			case "|" : return a | v;
			// return a AND v
			case "&" : return a & v;
			// return a power of v
			case "^" : return Math.pow(a, v);
			// return random a plus v
			case "#" : return a + rng() * v;
			// return a equal v
			default : return v;
		}
	}
	
	public function new() {
		super();
	}
	
}