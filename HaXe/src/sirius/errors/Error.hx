package sirius.errors;
import sirius.errors.IError;

/**
 * ...
 * @author Rafael Moreira
 */
class Error implements IError {
	
	public var object:Dynamic;
	
	public var message:String;
	
	public var code:UInt;

	public function new(code:UInt, message:String, ?object:Dynamic) {
		this.object = object;
		this.message = message;
		this.code = code;
	}
	
}