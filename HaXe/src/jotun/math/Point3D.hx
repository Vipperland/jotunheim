package jotun.math;
import jotun.math.IPoint3D;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Point3D implements IPoint3D {
	
	public var x:Float;
	
	public var y:Float;
	
	public var z:Float;
	
	public function new(x:Float,y:Float,z:Float) {
		update(x, y, z);
	}
	
	public function reset():Void {
		x = y = z = 0;
	}
	
	
	public function match(o:IPoint3D, ?round:Bool):Bool {
		return round 
				? Math.round(o.x) == Math.round(x) && Math.round(o.y) == Math.round(y) && Math.round(o.z) == Math.round(z) 
				:  o.x == x && o.y == y && o.z == z;
	}
	
	public function update(x:Float, y:Float, z:Float):IPoint3D {
		this.x = x;
		this.y = y;
		this.z = z;
		return this;
	}
	
}