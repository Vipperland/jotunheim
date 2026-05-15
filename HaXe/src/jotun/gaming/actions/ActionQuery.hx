package jotun.gaming.actions;
import haxe.DynamicAccess;
import haxe.Json;
import haxe.Rest;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.SpellCodex;
import jotun.math.RNG;
import jotun.objects.Query;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.utils.Filler;

/**
 * ...
 * @author Rim Project
 */
@:expose("Jtn.ActionQuery")
class ActionQuery extends Query {

	public static var RULE_EQUAL:String = "=";
	public static var RULE_ADD:String = "+";
	public static var RULE_SUBTRACT:String = "-";
	public static var RULE_INCREMENT:String = "++";
	public static var RULE_DECREMENT:String = "--";
	public static var RULE_MULTIPLY:String = "*";
	public static var RULE_DIVIDE:String = "/";
	public static var RULE_MOD:String = "%";
	public static var RULE_SHIFT_LEFT:String = "<<";
	public static var RULE_SHIFT_RIGHT:String = ">>";
	public static var RULE_BIT_NOT:String = "~";
	public static var RULE_BIT_OR:String = "|";
	public static var RULE_BIT_AND:String = "&";
	public static var RULE_BIT_XOR:String = "!";
	public static var RULE_POW:String = "^";
	public static var RULE_RANDOM:String = "#";

	public function getDataProvider():IDataProvider {
		return invocation.currentProvider;
	}

	private function _isempty(value:Dynamic):Bool {
		return value == null || value == "";
	}

	private function _BOOL(value:Dynamic):Bool {
		return Utils.boolean(value);
	}

	private function _INT(value:Dynamic, ?alt:Int):Int {
		var o:Int = Std.isOfType(value, String) ? Std.parseInt(value) : Std.isOfType(value, Int) ? value >> 0 : null;
		return o != null ? o : alt;
	}

	private function _FLOAT(value:Dynamic, ?alt:Float):Float {
		var o:Float = Std.isOfType(value, String) ? Std.parseFloat(value) : Std.isOfType(value, Float) ? value : null;
		return o != null ? o : alt;
	}

	private function _PARAMS(value:String):DynamicAccess<String> {
		var params:DynamicAccess<String> = {};
		if(value != null){
			value = value.split('+').join(' ');
			Dice.Values(value.split('&'), function(v:String){
				var data:Array<String> = v.split('=');
				if (data.length > 1){
					params.set(data[0], data[1]);
				}
			});
		}
		return params;
	}

	private function _JOIN(values:Array<Dynamic>):String {
		return values.join(' ');
	}

	private function _ASJSON(values:Array<Dynamic>):String {
		return Json.stringify(_JOIN(values));
	}

	private var _rng:RNG = null;

	public function seed(value:Float):ActionQuery {
		if (_rng == null) _rng = new RNG(value);
		else _rng.set(value);
		return this;
	}

	public function rng():Float {
		return _rng != null ? _rng.get() : Math.random();
	}

	private function _resolve(a:Dynamic, r:String, v:Dynamic):Dynamic {
		if (r == null) {
			r = "=";
		}
		return switch(r){
			// return a
			case "=","eq","equal" : a;
			// return a plus v
			case "+","add" : a + v;
			// return a minus v
			case "-","sub" : a - v;
			// return a plus 1
			case "++", "increment" : a + 1;
			// return a minus 1
			case "--", "decrement" : a - 1;
			// return a times 1
			case "*","multiply" : a * v;
			// return a divided v
			case "/","divided" : a / v;
			// return a module v
			case "%","mod" : a % v;
			// return a shift left
			case "<<", "lshift" : a << v;
			// return a shift right
			case ">>", "rshift": a >> v;
			// return a whithout v
			case "~","not" : a & ~(v >> 0);
			// return a OR v
			case "|","or" : a | v;
			// return a AND v
			case "&","and" : a & v;
			// return a XOR v
			case "!","xor" : a ^ v;
			// return a power of v
			case "^","pow" : Math.pow(a, v);
			// return random a plus v
			case "#", "random" : (rng() * v) + a;
			// return a equal v for unrecognized rule
			default : a;
		}
	}

	override private function _beforeProc(obj:Query):Void {
		if(Std.isOfType(obj, ActionQuery)) {
			(cast obj).invocation = invocation;
		}
	}

	public var invocation:SpellCasting;

	public function new() {
		super();
	}

	public function tracer(messages:Rest<String>):ActionQuery {
		trace("[ActionQuery:tracer] " + Filler.to(messages.toArray().join(" "), invocation));
		return this;
	}

	// =========================================== Call dialog chain ====================================================================================

	public function loadAction(id:String):Action {
		return SpellCodex.loadAction(id);
	}

	/**
	 * Call a registered Event chain
	 * @param	events
	 * @return
	 */
	public function call(id:String):ActionQuery {
		var action:Action = loadAction(id);
		if(action != null){
			action.invoke(invocation, 0);
		}
		return this;
	}

	// =========================================== VARIABLE MANIPULATION ====================================================================================

	/**
	   Set a random number to the var, can be float or int
		setrng var_name = 10 50 // effect: var_name = (any value from 10 to 50)
		setrng var_name = 100 // effect: var_name = (any value from 0 to 100)
	   @param	name
	   @param	rule
	   @param	min
	   @param	max
	   @param	float
	**/
	public function setrng(name:String, rule:String, min:Float, ?max:Float, ?float:Bool):ActionQuery {
		if (max == null) {
			max = min;
			min = 0;
		}
		var f:Bool = Utils.boolean(float);
		var a_min:Float = _FLOAT(min);
		var a_max:Float = _FLOAT(max) + (f ? 0 : 1) - a_min;
		var value:Float = rng() * a_max + a_min;
		(f ? setfloat : setint)(name, rule, f ? cast value : Std.int(value));
		return this;
	}

	/**
	   Set value to a variable
		setfloat var_name * 0.5 // effect: var_name*=0.5
		setfloat var_name / 0.5 // effect: var_name/=0.5
	   @param	name
	   @param	rule
	   @param	value
	**/
	public function setfloat(name:String, rule:String, value:Float):ActionQuery {
		var a:Float = getDataProvider().getFloat(name);
		if (_isempty(value) && !_isempty(rule)) {
			value = _FLOAT(rule);
			rule = null;
		}
		var v:Float = _FLOAT(value, 0);
		v = _resolve(a, rule, v);
		if (a != v) {
			getDataProvider().setVar(name, v);
		}
		return this;
	}

	/**
	   Set value to a variable
		setfloat var_name * 2 // effect: var_name*=2
		setfloat var_name / 2 // effect: var_name/=2
	   @param	name
	   @param	rule
	   @param	value
	**/
	public function setint(name:String, rule:String, value:Int):ActionQuery {
		var a:Float = getDataProvider().getInt(name);
		if (_isempty(value) && !_isempty(rule)) {
			value = _INT(rule);
			rule = null;
		}
		var v:Float = _INT(value, 0);
		v = _resolve(a, rule, v);
		if (a != v) {
			getDataProvider().setVar(name, Std.int(v));
		}
		return this;
	}

	/**
	   Set value to a variable
		setvar var_name = foobar // effect: var_name="foobar"
	   @param	name
	   @param	rule
	   @param	value
	**/
	public function setvar(name:String, rule:String, value:Dynamic):ActionQuery {
		var a:Dynamic = getDataProvider().getVar(name);
		if (_isempty(value)) {
			value = rule;
			rule = null;
		}
		if (Std.isOfType(a, String)) {
			return setstr(name, rule, value);
		} else if (Std.isOfType(a, Bool)) {
			return setswitch(name, value);
		} else {
			return setint(name, rule, value);
		}
	}

	/**
	 *
	 * @param	name
	 * @param	rule
	 * @param	value
	 * @return
	 */
	public function setstr(name:String, rule:String, value:String):ActionQuery {
		var a:String = getDataProvider().getStr(name);
		if (_isempty(value)) {
			value = rule;
			rule = null;
		}
		value = _resolve(a, rule, value);
		if (a != value) {
			getDataProvider().setStr(name, value);
		}
		return this;
	}

	/**
	 * Toggle Swith value
	 * @param	name
	 * @param	value
	 * @return
	 */
	public function setswitch(name:String, value:Bool):ActionQuery {
		var a:Bool = getDataProvider().getSwitch(name);
		var v:Bool = _isempty(value) || Utils.boolean(value);
		if (a != v) {
			getDataProvider().setSwitch(name, v);
		}
		return this;
	}

	/**
	 * Invert Swith value
	 * @param	name
	 * @param	value
	 * @return
	 */
	public function toggleswitch(name:String):ActionQuery {
		var a:Bool = getDataProvider().getSwitch(name);
		getDataProvider().setSwitch(name, !a);
		return this;
	}

	/**
	   Set variable with resolved value of A and B
		setfloat var_name * 2 // effect: var_name*=2
		setfloat var_name / 2 // effect: var_name/=2
	   @param	name
	   @param	rule
	   @param	value
	**/
	public function define(name:String, a:String, rule:String, b:String):ActionQuery {
		a = getDataProvider().getVar(a);
		b = getDataProvider().getVar(b);
		var v:Dynamic = _resolve(a, rule, b);
		if (a != v) {
			getDataProvider().setVar(name, v);
		}
		return this;
	}

	public function clamp(name:String, min:Float, max:Float):ActionQuery {
		var v:Float = _FLOAT(getDataProvider().getFloat(name), min);
		var c:Float = Math.max(min, Math.min(max, v));
		if (v != c) getDataProvider().setVar(name, c);
		return this;
	}

	public function copyto(source:String, target:String):ActionQuery {
		getDataProvider().setVar(target, getDataProvider().getVar(source));
		return this;
	}

	public function swap(nameA:String, nameB:String):ActionQuery {
		var a:Dynamic = getDataProvider().getVar(nameA);
		getDataProvider().setVar(nameA, getDataProvider().getVar(nameB));
		getDataProvider().setVar(nameB, a);
		return this;
	}

	#if js

	public function wait(?time:Float):ActionQuery {
		invocation.event.current.wait(time);
		return this;
	}

	public function release():ActionQuery {
		invocation.event.current.release();
		return this;
	}

	#end

}
