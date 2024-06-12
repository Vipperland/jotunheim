package jotun.gateway.domain;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.flags.GatewayOptions;
import jotun.logical.Flag;
import jotun.utils.Dice;
import jotun.utils.Omnitools;

/**
 * ...
 * @author Rafael Moreira
 */
class JsonOutput extends OutputCore {

	private var _manipulators:Dynamic;
	
	public function new() {
		super({});
		_manipulators = {};
	}
	
	override public function setOptions(value:Int):Void {
		if (Flag.FTest(value, GatewayOptions.DEBUG_MODE)){
			_data.input = InputCore.getInstance().allData();
			Reflect.deleteField(_data.input, 'service');
		}
		super.setOptions(value);
	}
	
	override public function object(name:String):ObjectManipulator {
		if (!Reflect.hasField(_data, name)){
			var o:Dynamic = {};
			Reflect.setField(_data, name, o);
			Reflect.setField(_manipulators, name, new ObjectManipulator(o, false));
		}
		return Reflect.field(_manipulators, name);
	}
	
	override public function list(name:String):ObjectManipulator {
		if (!Reflect.hasField(_data, name)){
			var o:Array<Dynamic> = [];
			Reflect.setField(_data, name, o);
			Reflect.setField(_manipulators, name, new ObjectManipulator(o, true));
		}
		return Reflect.field(_manipulators, name);
	}
	
	override public function flush():Void {
		_data.status = _status;
		_data.time = Omnitools.timeNow();
		Jotun.header.setJSON(_data, _encode_out, _chunk_size);
	}
	
}

private class ObjectManipulator {
	
	public var indexable(get, null):Bool;
	public function get_indexable():Bool {
		return indexable;
	}
	
	
	public var data(get, null):Dynamic;
	public function get_data():Dynamic {
		return data;
	}
	
	private function isIterable(value:Dynamic):Bool {
		return value != null && !Std.isOfType(value, String) && !Std.isOfType(value, Float) && !Std.isOfType(value, Bool);
	}
	
	public function new(data:Dynamic, indexable:Bool){
		this.data = data;
		this.indexable = indexable;
	}
	
	public function insert(o:Dynamic):Bool {
		if (indexable){
			data.push(o);
		}else if(Reflect.hasField(o, 'id')){
			Reflect.setField(data, o.id, o);
		}else{
			return false;
		}
		return true;
	}
	
	public function delete(id:Dynamic, ?silent:Bool):Dynamic {
		if (indexable){
			return Dice.Remove(data, id).pop();
		}else if(!isIterable(id)){
			Reflect.deleteField(data, id);
		}
		return id;
	}
	
	public function indexOf(value:Dynamic):Int {
		if (indexable){
			return data.indexOf(value);
		}else if(isIterable(value)){
			return Dice.Values(data, function(v:Dynamic){
				if (Reflect.hasField(data, 'id')){
					return data.id == value;
				}else{
					return false;
				}
			}).completed ? -1 : 0;
		}else{
			return -1;
		}
	}
	
	private function _test(obj:Dynamic, value:Dynamic):Bool {
		return !Dice.Values(obj, function(v:Dynamic){
			if(v != null){
				if (isIterable(v)){
					return v == value;
				}else if(Reflect.hasField(data, 'id')){
					return obj.id == value;
				}else {
					return _test(v, value);
				}
			}else{
				return false;
			}
		}).completed;
	}
	
	public function exists(id:String):Bool {
		return _test(data, id);
	}
	
}