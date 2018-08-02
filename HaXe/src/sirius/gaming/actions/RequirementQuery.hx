package sirius.gaming.actions;
import sirius.flow.Push;
import sirius.tools.Utils;

/**
 * ...
 * @author Rim Project
 */
class RequirementQuery extends Push {
	
	private function _isempty(value:String):Bool {
		return value == null || value == "";
	}
	
	private function _getint(value:String):Int {
		var o:Int = Std.parseInt(value);
		return o != null ? o : 0;
	}
	
	private function _resolve(a:Dynamic, r:String, v:Dynamic):Bool {
		if (r == null) r = ">=";
		switch(r){
			case "<" : return a < v;
			case "<=" : return a <= v;
			case ">" : return a > v;
			case ">=" : return a >= v;
			case "!=" : return a != v;
			case "*=" : return a.indexOf(v) != -1;
			case "~=" : return v.indexOf(a) != -1;
		}
		return a == v;
	}
	
	public function new() {
		super();
	}
	
}