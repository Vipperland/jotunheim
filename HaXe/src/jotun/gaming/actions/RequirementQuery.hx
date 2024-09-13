package jotun.gaming.actions;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.BasicDataProvider;
import jotun.gaming.actions.EventContext;
import jotun.gaming.actions.IDataProvider;
import jotun.objects.Query;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_RequirementQuery")
class RequirementQuery extends Query {
	
	public static var RULE_EQUAL:String = "=";
	public static var RULE_DIFFERENT:String = "!=";
	public static var RULE_LESS:String = "<";
	public static var RULE_LESS_OR:String = "<=";
	public static var RULE_GREAT:String = ">";
	public static var RULE_GREAT_OR:String = ">=";
	public static var RULE_BIT:String = "&";
	public static var RULE_BIT_NOT:String = "!&";
	public static var RULE_CONTAIN:String = "*=";
	public static var RULE_INSIDE:String = "~=";
	public static var RULE_RANDOM_EQUAL:String = "#=";
	public static var RULE_RANDOM_DIFFENT:String = "#!";
	public static var RULE_RANDOM_GREAT_OR:String = "#>";
	public static var RULE_RANDOM_LESS_OR:String = "#<";
	
	public function getDataProvider():IDataProvider {
		return ioContext.currentProvider;
	}
	
	private function _isempty(value:Dynamic):Bool {
		return value == null || value == "";
	}
	
	private function _INT(value:Dynamic, alt:Int):Int {
		var o:Int = Std.isOfType(value, String) ? Std.parseInt(value) : Std.isOfType(value, Int) ? value >> 0 : null;
		return o != null ? o : alt;
	}
	
	private function _FLOAT(value:Dynamic, alt:Float):Float {
		var o:Float = Std.isOfType(value, String) ? Std.parseFloat(value) : Std.isOfType(value, Float) ? value : null;
		return o != null ? o : alt;
	}
	
	public function rng():Float {
		return Math.random();
	}
	
	private function _rule(rule:String, alt:String):String {
		return rule != null ? rule : alt;
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
			case "<=","less-or" : a <= v;
			// if a greater than v
			case ">","great": a > v;
			// if a greater than or equal v
			case ">=","great-or" : a >= v;
			// if a contain bit v
			case "&","test" : (a & v) == v;
			// if a don't contain bit v
			case "!&","not": (~a & v) == v;
			// if a contain b
			case "*=","contain" : a.indexOf(v) != -1;
			// if b contain a
			case "~=","inside" : v.indexOf(a) != -1;
			// if random * a is equal b
			case "#=","rand" : Std.int(rng() * a) == (v >> 0);
			// if random * a is different b
			case "#!","rand-diff" : Std.int(rng() * a) != (v >> 0);
			// if random * a greater then or equal  b
			case "#>","rand-great-or" : (rng() * a) >= v;
			// if random * a lesser then or equal  b
			case "#<","rand-less-or" : (rng() * a) <= v;
			// if a is equal b
			default : a == v;
		}
	}
	
	public var ioContext:EventContext;
	
	public function new() {
		super();
	}
	
	// =========================================== VARIABLE VERIFICATIONS ====================================================================================

	/**
	   Do a getvar() but use a value of random number generator
	   @param	name
	   @param	rule
	   @param	min
	   @param	max
	**/
	public function isrng(name:String, rule:String, min:Float, ?max:Float, ?float:Bool):Bool {
		if (max == null){
			max = min;
			min = 0;
		}
		var f:Bool = Utils.boolean(float);
		var a_min:Float = _FLOAT(min, 0);
		var a_max:Float = _FLOAT(max, 0) + (f ? 0 : 1) - a_min;
		var value:Float = (rng() * a_max + a_min);
		return isvar(name, rule, value);
	}
	
	/**
	 * Match a Variable Value
	 * Rules:
	 * 			varname <  value
	 * 			varname <= value
	 * 			varname >  value
	 * 			varname >= value
	 * 			varname != value
	 * 			varname &  value
	 * 			varname !& value
	 * 			varname =  value
	 * @param	name		variable name
	 * @param	rule		verification rule
	 * @param	value	target value
	 * @return
	 */
	public function isvar(name:String, rule:String, value:Float):Bool {
		var a:Float = getDataProvider().getVar(name);
		if (_isempty(value) && !_isempty(rule)){
			value = _FLOAT(rule, 0);
			rule = null;
		}
		return _resolve(a, rule, _FLOAT(value, 0));
	}
	
	/**
	 * Match a String Value
	 * Rules:
	 * 			varname != value
	 * 			varname *= value
	 * 			varname ~= value
	 * 			varname =  value
	 * @param	name		variable name
	 * @param	rule		verification rule
	 * @param	value	target value
	 * @return
	 */
	public function isstr(name:String, rule:String, value:String):Bool {
		var a:String = getDataProvider().getStr(name);
		if (_isempty(value)){
			value = rule;
			rule = null;
		}
		return _resolve(a, rule, value);
	}
	
	/**
	 * Check if switch is TRUE or FALSE
	 * @param	name
	 * @param	value
	 * @return
	 */
	public function isswitch(name:String, value:Bool):Bool {
		var a:Bool = getDataProvider().getSwitch(name);
		return (_isempty(value) || Utils.boolean(value)) == a;
	}
	
	
	public function hasrequestcontext():Bool {
		return ioContext.requestProvider != null;
	}
	
	public function isrequestcontext():Bool {
		return hasrequestcontext() && ioContext.requestProvider == ioContext.currentProvider;
	}
	
	public function ismaincontext():Bool {
		return ioContext.dataProvider == ioContext.currentProvider;
	}
	
	
	// =========================================== CONTEXT VERIFICATIONS ====================================================================================

	/**
	 * Check if event origin is of type
	 * @param	...rest
	 * @return
	 */
	public function iseventtype(...types:String):Bool {
		return !Dice.Values(types, function(v:String){
			return v == ioContext.origin.type;
		}).completed;
	}
	
	/**
	 * Check if 
	 * @param	...ids
	 * @return
	 */
	public function isactionid(...ids:String):Bool {
		if(ioContext.action != null && ioContext.action.target != null && ioContext.action.target.id != null){
			return false;
		}
		return !Dice.Values(ids, function(v:String){
			return v == ioContext.action.target.id;
		}).completed;
	}
	
	/**
	 * 
	 * @param	hits
	 * @param	...ids
	 * @return
	 */
	public function isactionchain(hits:Int, ...ids:String):Bool {
		var matches:Int = 0;
		if(hits <= 0 || hits > ids.length){
			hits = ids.length;
		}
		return !Dice.Values(ioContext.history, function(a:Action):Bool {
			if(a.id == ids[matches]){
				++matches;
			}
			return matches >= hits;
		}).completed;
	}
	
	/**
	 * 
	 * @param	...ids
	 * @return
	 */
	public function isafteranyaction(...ids:String):Bool {
		var matches:Int = 0;
		return !Dice.Values(ids, function(id:String):Bool {
			return !Dice.Values(ioContext.history, function(a:Action):Bool {
				return id != null && id.length > 0 && a.id == id;
			}).completed;
		}).completed;
		
	}
	
	/**
	 * 
	 * @return
	 */
	public function isdebug():Bool {
		return ioContext.debug;
	}
	
}