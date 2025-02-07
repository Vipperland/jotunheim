package jotun.net;
import haxe.DynamicAccess;
import haxe.Json;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class DataSource {

	public var data:DynamicAccess<Dynamic>;
	
	public function new(data:DynamicAccess<Dynamic>){
		this.data = data;
	}
	
	public function get(q:String, ?alt:Dynamic):Dynamic {
		if (exists(q)){
			return data.get(q);
		}
		return alt;
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
	
	final public function merge(data:Dynamic):Void {
		Dice.Blend(data, this.data);
	}
	
	public function exists(q:String):Bool {
		return data != null && data.exists(q);
	}
	
	public function isEmpty():Bool {
		return Dice.Params(data, function(p:String){
			return true;
		}).completed;
	}
	
	public function remove(q:String):Void {
		data.remove(q);
	}
	
	public function toString():String {
		return Json.stringify(data);
	}
	
}