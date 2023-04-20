package jotun.gateway.domain;
import jotun.Jotun;
import jotun.gateway.database.objects.ZoneCoreSession;
import jotun.gateway.domain.Input;
import jotun.gateway.utils.Omnitools;

/**
 * ...
 * @author 
 */
class Output {
	
	static public var ME(get, null):Output;
	static private function get_ME():Output {
		if (ME == null){
			ME = new Output();
		}
		return ME;
	}
	
	private var _log:Bool;
	
	private var _data:Dynamic;
	
	public function new() {
		_data = { }
	}
	
	public function object(name:String):Dynamic {
		if (!Reflect.hasField(_data, name)){
			Reflect.setField(_data, name, {});
		}
		return Reflect.field(_data, name);
	}
	
	public function list(name:String):Dynamic {
		if (!Reflect.hasField(_data, name)){
			Reflect.setField(_data, name, []);
		}
		return Reflect.field(_data, name);
	}
	
	public function enableLog():Void {
		_log = true;
		if (Input.ME.hasAnyParam() || Input.ME.object != null){
			_data.input = {
				params: Input.ME.hasAnyParam() ? Input.ME.params : null,
				json: Input.ME.object,
			};
		}
		list("errors");
	}
	
	public function log(message:Dynamic, ?list:String = 'trace'):Void {
		if (_log){
			this.list(list).push(message);
		}
	}
	
	public function error(code:Int):Void {
		list("errors").push(code);
	}
	
	public function hasError(code:Int):Bool{
		return list("errors").indexOf(code) != -1;
	}
	
	public function flush():Void {
		_data.time = Omnitools.timeNow();
		if (Jotun.gate.isLogEnabled()){
			_data.database = Jotun.gate.log;
		}
		Jotun.header.setJSON(_data);
	}
	
	public function registerOAuth(token:String):Void {
		Jotun.header.setOAuth(token);
	}
	
}