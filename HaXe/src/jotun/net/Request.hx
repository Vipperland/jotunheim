package jotun.net;
import haxe.Json;
import jotun.errors.Error;
import jotun.gaming.dataform.Pulsar;

/**
 * ...
 * @author Rafael Moreira
 */
class Request implements IRequest {
	
	public var url:String;
	
	public var data:String;
	
	public var success:Bool;
	
	public var error:Error;
	
	public var headers:Dynamic;

	public function new(success:Bool, data:String, ?error:Error, ?url:String, ?headers:Dynamic) {
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
	
	public function pulsar():Pulsar {
		return Pulsar.create(data);
	}
	
	public function getHeader(name:String):String {
		return Reflect.field(headers, name.toLowerCase());
	}
	
}