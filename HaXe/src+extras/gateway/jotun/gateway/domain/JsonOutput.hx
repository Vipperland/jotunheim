package jotun.gateway.domain;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.utils.Omnitools;

/**
 * ...
 * @author Rafael Moreira
 */
class JsonOutput extends OutputCore {

	public function new() {
		super({});
	}
	
	override public function enableLog():Void {
		if (InputCore.getInstance().hasAnyParam() || InputCore.getInstance().object != null){
			_data.input = {
				params: InputCore.getInstance().hasAnyParam() ? InputCore.getInstance().params : null,
				json: InputCore.getInstance().object,
			};
		}
		super.enableLog();
	}
	
	override public function object(name:String):Dynamic {
		if (!Reflect.hasField(_data, name)){
			Reflect.setField(_data, name, {});
		}
		return Reflect.field(_data, name);
	}
	
	override public function list(name:String):Dynamic {
		if (!Reflect.hasField(_data, name)){
			Reflect.setField(_data, name, []);
		}
		return Reflect.field(_data, name);
	}
	
	override public function flush():Void {
		if (Jotun.gate.isLogEnabled()){
			_data.database = Jotun.gate.log;
		}
		_data.time = Omnitools.timeNow();
		Jotun.header.setJSON(_data);
	}
	
}