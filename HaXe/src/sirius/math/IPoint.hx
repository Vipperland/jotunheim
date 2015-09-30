package sirius.math;
import sirius.math.IPoint;

/**
 * @author Rafael Moreira
 */

interface IPoint {
	public var x:Float;
	public var y:Float;
	public function reset():Void;
	public function match(o:IPoint, ?round:Bool):Bool;
}