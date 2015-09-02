package sirius.modules;

/**
 * @author Rafael Moreira
 */

interface IRequest {
	public var data:String;
	public var success:Bool;
	public function json():Dynamic;
}