package jotun.net;
import js.html.DOMError;

/**
 * ...
 * @author Rafael Moreira
 */
class Response {
	
	public var data:Dynamic;
	public var error:DOMError;
	public var request:js.html.Request;
	public var response:js.html.Response;
	
	public var success:Bool;

	public function new(request:js.html.Request, response:js.html.Response, data:Dynamic, error:DOMError) {
		this.data = data;
		this.error = error;
		this.request = request;
		this.response = response;
		this.success = error == null;
	}
	
}