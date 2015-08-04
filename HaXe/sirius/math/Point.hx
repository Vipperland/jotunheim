package sirius.math;
import math.IPoint;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Point implements IPoint {
	
	public var x:Float;
	
	public var y:Float;
	
	public function new(x:Float,y:Float) {
		this.x = x;
		this.y = y;
	}
	
}