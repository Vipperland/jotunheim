package errors;

/**
 * @author Rafael Moreira
 */

interface IError {
  
	public var object:Dynamic;
	
	public var message:String;
	
	public var code:UInt;
	
}