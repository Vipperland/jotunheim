package jotun.gaming.actions;
import jotun.flow.Push;

/**
 * ...
 * @author Rim Project
 */
@:expose("jtn.game.ActionQuery")
class ActionQuery extends Push {

	private function _isempty(value:String):Bool {
		return value == null || value == "";
	}
	
	private function _N(value:String):Float {
		var o:Float = Std.parseFloat(value);
		return o != null ? o : 0;
	}
	
	private static function _resolve(a:Dynamic, r:String, v:Dynamic):Dynamic {
		if (r == null) {
			r = "=";
		}
		switch(r){
			case "=" : return v;
			case "+" : return a + v;
			case "-" : return a - v;
			case "++" : return a + 1;
			case "--" : return a - 1;
			case "*" : return a * v;
			case "/" : return a / v;
			case "%" : return a % v;
			case "<<" : return a << v;
			case ">>" : return a >> v;
			case "~" : return a & ~(v >> 0);
			case "|" : return a | v;
			case "&" : return a & v;
			case "^" : return Math.pow(a, v);
		}
		return a + v;
	}
	
	public function new() {
		super();
	}
	
}