package jotun.gaming.actions;
import haxe.Rest;
import jotun.objects.Query;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.utils.Filler;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_ActionQuery")
class ActionQuery extends Query {

	private function _isempty(value:Dynamic):Bool {
		return value == null || value == "";
	}
	
	private function _PARAMS(value:String):Dynamic {
		var params:Dynamic = {};
		if(value != null){
			value = value.split('+').join(' ');
			Dice.Values(value.split('&'), function(v:String){
				var data:Array<Dynamic> = v.split('=');
				if (data.length > 1){
					Reflect.setField(params, data[0], data[1]);
				}
			});
		}
		return params;
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
	
	public function rng():Float {
		return Math.random();
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
			// return a equal v
			default : a;
		}
	}
	
	public var ioContext:EventContext;
	
	/**
	 * 
	 */
	public function new() {
		super();
	}
	
	public function tracer(messages:Rest<String>):ActionQuery {
		trace("[ActionQuery:tracer] " + Filler.to(messages.toArray().join(" "), ioContext));
		return this;
	}
	
}