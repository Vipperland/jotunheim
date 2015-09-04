package sirius.errors;

/**
 * ...
 * @author Rafael Moreira
 */
class Error {
	
	public var message:String;
	
	public var code:UInt;

	public function new(code:UInt, message:String) {
		this.message = message;
		this.code = code;
	}
	
}