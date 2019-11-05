package jotun.errors;
import jotun.errors.IError;

/**
 * ...
 * @author Rafael Moreira
 */
class Error implements IError {
	
	public var object:Dynamic;
	
	public var message:Dynamic;
	
	public var code:Dynamic;

	public function new(code:Dynamic, message:Dynamic, ?object:Dynamic) {
		this.object = object;
		this.message = message;
		this.code = code;
	}
	
}