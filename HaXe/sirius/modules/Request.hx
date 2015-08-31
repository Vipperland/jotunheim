package modules;
import haxe.Json;

/**
 * ...
 * @author Rafael Moreira
 */
class Request implements IRequest {
	
	public var data:String;
	
	public var success:Bool;

	public function new(success:Bool, data:String) {
		this.data = data;
		this.success = success;
	}
	
	/* INTERFACE modules.IRequest */
	
	public function json():Dynamic {
		return data != null ? Json.parse(data) : null;
	}
	
}