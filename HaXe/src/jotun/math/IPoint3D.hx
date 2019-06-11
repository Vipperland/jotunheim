package jotun.math;

/**
 * @author Rafael Moreira
 */

interface IPoint3D {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public function reset():Void;
	public function match(o:IPoint3D, ?round:Bool):Bool;
}