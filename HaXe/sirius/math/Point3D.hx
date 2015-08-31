package sirius.math;
import sirius.math.IPoint3D;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Point3D implements IPoint3D {
	
	public var x:Float;
	
	public var y:Float;
	
	public var z:Float;
	
	public function new(x:Float,y:Float,z:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
}