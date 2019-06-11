package jotun.css;
import haxe.Log;
import jotun.dom.Display3D;
import jotun.dom.IDisplay;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("XCSS")
class XCSS{
	
	public var data:Dynamic;
	
	static public var enabled:Bool = false;
	
	static public function create(target:IDisplay, data:Dynamic):XCSS {
		return new XCSS(data).apply(target);
	}
	
	public function new(?data:Dynamic) {
		reset();
		if(data != null) flush(data);
	}
	
	public function flush(data:Dynamic):Void {
		Dice.All(data, write);
	}
	
	public function write(param:String, value:String):Void {
		if(enabled == true){
			var cx:String = param.substr(0, 1).toUpperCase() + param.substr(1, param.length - 1);
			Reflect.setField(this.data, "webkit" + cx, value);
			Reflect.setField(this.data, "Moz" + cx, value);
			Reflect.setField(this.data, "ms" + cx, value);
			Reflect.setField(this.data, "O" + cx, value);
		}
		Reflect.setField(this.data, param, value);
	}
	
	public function apply(target:IDisplay):XCSS {
		target.style(this.data);
		return this;
	}
	
	public function reset():XCSS {
		this.data = { };
		return this;
	}
	
}