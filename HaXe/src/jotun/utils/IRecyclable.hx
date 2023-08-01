package jotun.utils;

/**
 * @author Rafael Moreira
 */
interface IRecyclable {
	public var isDisposed:Bool;
	public function dispose():Void;
	public function build(...rest:Dynamic):Void;
}