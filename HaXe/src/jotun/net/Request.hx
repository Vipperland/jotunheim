package jotun.net;
import haxe.DynamicAccess;
import haxe.Json;
import jotun.errors.Error;

/**
 * ...
 * @author Rafael Moreira
 */
class Request implements IRequest {
	
	public var url:String;
	
	public var data:String;
	
	public var success:Bool;
	
	public var error:Error;
	
	public var headers:DynamicAccess<String>;

	public function new(success:Bool, data:String, ?error:Error, ?url:String, ?headers:DynamicAccess<String>) {
		this.url = url;
		this.error = error;
		this.data = data;
		this.success = success;
		this.headers = headers;
	}
	
	/* INTERFACE modules.IRequest */
	
	public function object():Dynamic {
		return data != null && data.length > 1 ? Json.parse(data) : null;
	}
	
	public function getHeader(name:String):String {
		return headers != null ? headers.get(name.toLowerCase()) : null;
	}
	
}