package jotun.math;
import jotun.math.IPoint;

/**
 * @author Rafael Moreira
 */

interface IPoint {
	public var x:Float;
	public var y:Float;
	public function reset():Void;
	public function match(o:IPoint, ?round:Bool):Bool;
	public function length():Float;
	public function distanceOf(point:Point):Float;
}