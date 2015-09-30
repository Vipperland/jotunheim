package sirius.modules;
import sirius.errors.Error;

/**
 * @author Rafael Moreira
 */

interface IRequest {
	public var data:String;
	public var success:Bool;
	public var error:Error;
	public function object():Dynamic;
}