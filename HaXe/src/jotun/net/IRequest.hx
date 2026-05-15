package jotun.net;
import haxe.DynamicAccess;
import jotun.errors.Error;

/**
 * @author Rafael Moreira
 */

interface IRequest {
	public var url:String;
	public var data:String;
	public var success:Bool;
	public var error:Error;
	public var headers:DynamicAccess<String>;
	public function object():Dynamic;
	public function getHeader(name:String):String;
}