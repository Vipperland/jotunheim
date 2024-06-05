package jotun.gateway.domain;
import jotun.Jotun;
import jotun.gateway.domain.InputCore;
import jotun.gateway.flags.GatewayOptions;
import jotun.gateway.objects.InputCoreCarrier;
import jotun.logical.Flag;
import jotun.utils.Omnitools;
import php.ErrorException;

/**
 * ...
 * @author 
 */
class OutputCore extends InputCoreCarrier {
	
	static private var _instance:OutputCore;
	static public function getInstance():OutputCore {
		return _instance;
	}
	
	private var _log:Bool;
	
	private var _status:Int;
	
	private var _stopped:Bool;
	
	private var _encode_out:Bool;
	
	private var _chunk_size:Int;
	
	private var _data:Dynamic;
	
	public function new(data:Dynamic) {
		if (_instance != null){
			throw new ErrorException("gateway.Output is a Singleton");
		}
		_status = 200;
		_instance = this;
		_data = data;
		super();
	}
	
	final public function mode(output:Bool, ?chunk:Int = 40):Void {
		_encode_out = output;
		_chunk_size = chunk;
	}
	
	public function object(name:String):Dynamic {
		return null;
	}
	
	public function list(name:String):Dynamic {
		return null;
	}
	
	public function setOptions(value:Int):Void {
		if (Flag.FTest(value, GatewayOptions.INFO_LOG)){
			_log = true;
		}
	}
	
	public function log(message:Dynamic, ?list:String = 'trace'):Void {
		if (_log){
			this.list(list).insert(message);
		}
	}
	
	public function error(code:Int, check:Bool = false):Void {
		if (!_stopped && (!check || !hasError(code))){
			list("errors").insert(code);
		}
	}
	
	final public function hasError(code:Int):Bool{
		return list("errors").indexOf(code) != -1;
	}
	
	final public function setStatus(code:Int):Void {
		_status = code;
	}
	
	final public function getStatus():Int {
		return _status;
	}
	
	public function flush():Void {
	}
	
	public function registerOAuth(token:String):Void {
		Jotun.header.setOAuth(token);
	}
	
	final public function isStopped():Bool {
		return _stopped == true;
	}
	
	final public function isLogEnabled():Bool {
		return _log == true;
	}
	
}