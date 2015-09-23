package sirius.modules;
import haxe.Json;
import sirius.errors.Error;

/**
 * ...
 * @author Rafael Moreira
 */
class Request implements IRequest {
	
	public var data:String;
	
	public var success:Bool;
	
	public var error:Error;

	public function new(success:Bool, data:String, ?error:Error) {
		this.error = error;
		this.data = data;
		this.success = success;
	}
	
	/* INTERFACE modules.IRequest */
	
	public function json():Dynamic {
		return data != null && data.length > 1 ? Json.parse(data) : null;
	}
	
}