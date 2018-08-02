package sirius.gaming.actions;
import sirius.flow.Push;
import sirius.tools.Flag;
import sirius.tools.Utils;

/**
 * ...
 * @author Rim Project
 */
class ActionQuery extends Push {

	private function _isempty(value:String):Bool {
		return value == null || value == "";
	}
	
	private function _getint(value:String):Int {
		var o:Int = Std.parseInt(value);
		return o != null ? o : 0;
	}
	
	private static function _resolve(a:Dynamic, r:String, v:Dynamic):Dynamic {
		if (r == null) r = "=";
		switch(r){
			case "=" : return v;
			case "++" : return a + v;
			case "+" : return ++a;
			case "--" : return --a;
			case "-" : return a - v;
			case "*" : return a * v;
			case "/" : return a / v;
			case "%" : return a % v;
			case "<" : return Flag.FPut(a, 1<<v);
			case ">" : return Flag.FDrop(a, 1<<v);
			case "|" : return a | v;
			case "&" : return a & v;
			case "^" : return Math.pow(a, v);
		}
		return a == v;
	}
	
	public function new() {
		super();
	}
	
}