package jotun.math;
import jotun.math.IPoint3D;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Point3D implements IPoint3D {
	
	static public function distance(x1:Float, y1:Float, z1:Float, x2:Float, y2:Float, z2:Float):Float {
		x1 = (x1 - x2);
		y1 = (y1 - y2);
		z1 = (z1 - z2);
		x1 = x1 * x1;
		y1 = y1 * y1;
		z1 = z1 * z1;
		return Math.sqrt(x1 + y1 + z1);
	}
	
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
	
	public function magnitude():Float {
		return Math.sqrt(x * x + y * y + z * z);
	}
	
	public function distanceOf(point:Point3D):Float {
		return distance(point.x, point.y, point.z, x, y, z);
	}
	
}