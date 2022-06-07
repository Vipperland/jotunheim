package jotun.gaming.actions;
import jotun.objects.Query;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_ActionQuery")
class ActionQuery extends Query {

	private function _isempty(value:String):Bool {
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
	
	private function _INT(value:Dynamic, ?alt:Int = 0):Int {
		var o:Int = Std.is(value, String) ? Std.parseInt(value) : Std.int(value);
		return o != null ? o : alt;
	}
	
	private function _FLOAT(value:Dynamic, ?alt:Float = 0):Float {
		var o:Float = Std.is(value, String) ? Std.parseFloat(value) : Std.int(value);
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
			case "=","equal" : a;
			// return a plus v
			case "+","plus" : a + v;
			// return a minus v
			case "-","minus" : a - v;
			// return a plus 1
			case "++" : a + 1;
			// return a minus 1
			case "--" : a - 1;
			// return a times 1
			case "*","multiply" : a * v;
			// return a divided v
			case "/","divided" : a / v;
			// return a module v
			case "%","module" : a % v;
			// return a shift left
			case "<<" : a << v;
			// return a shift right
			case ">>" : a >> v;
			// return a whithout v
			case "~","not" : a & ~(v >> 0);
			// return a OR v
			case "|","or" : a | v;
			// return a AND v
			case "&","and" : a & v;
			// return a XOR v
			case "^","xor" : a ^ v;
			// return a power of v
			case "!","pow" : Math.pow(a, v);
			// return random a plus v
			case "#", "random" : (rng() * v) + a;
			// return a equal v
			default : a;
		}
	}
	
	public var ioContext:IEventContext;
	
	/**
	 * 
	 */
	public function new() {
		super();
	}
	
}