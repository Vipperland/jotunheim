package sirius.math;
import sirius.math.IPoint;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose('sru.math.point')
class Point implements IPoint {
	
	static public function distance(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		var rx:Float = (x1 - x2);
		var ry:Float = (y1 - y2);
		rx = rx * rx;
		ry = ry * ry;
		return Math.sqrt(rx + ry);
	}
	
	public var x:Float;
	
	public var y:Float;
	
	public function new(x:Float,y:Float) {
		this.x = x;
		this.y = y;
	}
	
	public function reset():Void {
		x = y = 0;
	}
	
	public function match(o:IPoint, ?round:Bool):Bool {
		return round 
				? Math.round(o.x) == Math.round(x) && Math.round(o.y) == Math.round(y) 
				: o.x == x && o.y == y;
	}
	
	public function add(q:IPoint):IPoint {
		x += q.x;
		y += q.y;
		return this;
	}
	
}