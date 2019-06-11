package jotun.errors;
import jotun.errors.IError;

/**
 * ...
 * @author Rafael Moreira
 */
class Error implements IError {
	
	public var object:Dynamic;
	
	public var message:String;
	
	public var code:Dynamic;

	public function new(code:Dynamic, message:String, ?object:Dynamic) {
		this.object = object;
		this.message = message;
		this.code = code;
	}
	
}