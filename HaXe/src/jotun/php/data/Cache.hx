package jotun.php.data;
import php.Lib;

/**
 * ...
 * @author Rafael Moreira
 */
class Cache {

	public function new() {
		
	}
	
	public function set(name:String, value:Array<Dynamic>):Void {
		Reflect.setField(this, name, value);
	}
	
	public function add(name:String, value:Array<Dynamic>):Void {
		if (hasField(name)) {
			Reflect.setField(this, name, get(name).concat(value));
		}else {
			Reflect.setField(this, name, value);
		}
	}
	
	public function get(name:String):Array<Dynamic> {
		return Reflect.field(this, name);
	}
	
	public function hasField(name:String):Bool {
		return Reflect.hasField(this, name);
	}
	
	public function json(?print:Bool = true, ?encoding:Dynamic = null):String {
		var result:String = untyped __php__("json_encode($this,256)");
		if (encoding != null) result = encoding(result);
		if (print) Lib.print(result);
		return result;
	}
	
}