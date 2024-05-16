package jotun.gaming.actions;
import haxe.DynamicAccess;
import jotun.gaming.actions.IDataProvider;
import jotun.utils.Dice;

/**
 * @author Rafael Moreira
 */
class BasicDataProvider implements IDataProvider {
	
	static private var _instances:DynamicAccess<IDataProvider> = {};
	
	static public function get(name:String):IDataProvider {
		if(!_instances.exists(name)){
			_instances.set(name, cast new BasicDataProvider({ }));
		}
		return _instances.get(name);
	}
	
	static public function set(name:String, data:IDataProvider):IDataProvider {
		_instances.set(name, data);
		return data;
	}
	
	static public function drop(name:String):Void {
		_instances.remove(name);
	}
	
	private var _data:DynamicAccess<Dynamic>;
	
	public function new(data:DynamicAccess<Dynamic>) {
		_data = data;
	}
	
	/* INTERFACE jotun.gaming.actions.IDataProvider */
	
	public function hasVar(name:String):Bool {
		return _data.exists(name);
	}
	
	public function getVar(name:String):Dynamic {
		return _data.get(name);
	}
	
	public function getStr(name:String):String {
		return hasVar(name) ? Std.string(getVar(name)) : "";
	}
	
	public function getInt(name:String):Int {
		return hasVar(name) ? Std.int(getVar(name)) : 0;
	}
	
	public function getFloat(name:String):Float {
		return Std.parseFloat(getVar(name));
	}
	
	public function getSwitch(name:String):Bool {
		return getInt(name) > 0;
	}
	
	public function setVar(name:String, value:Dynamic):Void {
		_data.set(name, value);
	}
	
	public function setStr(name:String, value:Dynamic):Void {
		_data.set(name, Std.string(value));
	}
	
	public function setSwitch(name:String, value:Bool):Void {
		if(value == null){
			_data.remove(name);
		}else {
			_data.set(name, value ? 1 : 0);
		}
	}
	
	public function merge(data:DynamicAccess<Dynamic>):Void {
		Dice.All(data, function(p:Dynamic, v:Dynamic):Void {
			_data.set(p, v);
		});
	}
	
}