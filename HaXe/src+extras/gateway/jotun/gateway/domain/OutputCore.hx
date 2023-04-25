package jotun.gateway.domain;
import jotun.Jotun;
import jotun.gateway.domain.InputCore;
import jotun.gateway.utils.Omnitools;
import php.ErrorException;

/**
 * ...
 * @author 
 */
class OutputCore {
	
	static private var _instance:OutputCore;
	static public function getInstance():OutputCore {
		return _instance;
	}
	
	private var _log:Bool;
	
	private var _data:Dynamic;
	
	public function new(data:Dynamic) {
		if (_instance != null){
			throw new ErrorException("gateway.Output is a Singleton");
		}
		_instance = this;
		_data = data;
	}
	
	public function object(name:String):Dynamic {
		return null;
	}
	
	public function list(name:String):Dynamic {
		return null;
	}
	
	public function enableLog():Void {
		_log = true;
	}
	
	public function log(message:Dynamic, ?list:String = 'trace'):Void {
		if (_log){
			this.list(list).push(message);
		}
	}
	
	public function error(code:Int, check:Bool = false):Void {
		if (!check || !hasError(code)){
			list("errors").push(code);
		}
	}
	
	public function hasError(code:Int):Bool{
		return list("errors").indexOf(code) != -1;
	}
	
	public function flush():Void {
	}
	
	public function registerOAuth(token:String):Void {
		Jotun.header.setOAuth(token);
	}
	
}