package sirius.net;
import haxe.Json;
import sirius.errors.Error;

/**
 * ...
 * @author Rafael Moreira
 */
class Request implements IRequest {
	
	public var url:String;
	
	public var data:String;
	
	public var success:Bool;
	
	public var error:Error;

	public function new(success:Bool, data:String, ?error:Error, ?url:String) {
		this.url = url;
		this.error = error;
		this.data = data;
		this.success = success;
	}
	
	/* INTERFACE modules.IRequest */
	
	public function object():Dynamic {
		return data != null && data.length > 1 ? Json.parse(data) : null;
	}
	
}