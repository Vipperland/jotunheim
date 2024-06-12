package jotun.gateway.domain;
import haxe.DynamicAccess;
import haxe.Json;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class InputDataSource {
	
	public var data:DynamicAccess<Dynamic>;
	
	public function get(q:String, ?alt:Dynamic):Dynamic {
		if (exists(q)){
			return data.get(q);
		}
		return alt;
	}
	
	public function new(data:DynamicAccess<Dynamic>){
		this.data = data;
	}
	
	final public function bool(q:String, ?alt:Bool):Bool {
		return Utils.boolean(get(q, alt));
	}
	
	final public function int(q:String, ?alt:Int):Int {
		return Std.parseInt(get(q, alt));
	}
	
	final public function float(q:String, ?alt:Float):Float {
		return Std.parseFloat(get(q, alt));
	}
	
	final public function string(q:String, ?alt:String):String {
		return get(q, alt);
	}
	
	final public function array(q:String, ?split:String = ','):Array<Dynamic> {
		return string(q, "").split(split);
	}
	
	final public function parse(q:String):Dynamic {
		return Json.parse(string(q, "{}"));
	}
	
	public function isEmpty():Bool {
		return Dice.Params(data, function(p:String){
			return true;
		}).completed;
	}
	
	public function exists(q:String):Bool {
		return data != null && data.exists(q);
	}
	
}