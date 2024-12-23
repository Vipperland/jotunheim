package jotun.net;
import jotun.errors.Error;

/**
 * @author Rafael Moreira
 */

interface IRequest {
	public var url:String;
	public var data:String;
	public var success:Bool;
	public var error:Error;
	public var headers:Dynamic;
	public function object():Dynamic;
	public function getHeader(name:String):String;
}