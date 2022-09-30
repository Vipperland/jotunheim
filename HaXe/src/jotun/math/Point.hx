package jotun.math;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose('J_Point')
class Point {
	
	static public function distance(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		x1 = (x1 - x2);
		y1 = (y1 - y2);
		x1 = x1 * x1;
		y1 = y1 * y1;
		return Math.sqrt(x1 + y1);
	}
	
	static public function hilbert(n:Int, d:Int):Point {
		var rx:Int;
		var ry:Int;
		var t:Float = d;
		var x:Int = 0;
		var y:Int = 0;
		var s:Int = 0;
		while(s < n) {
			rx = 1 & (cast (cast t) / 2);
			ry = 1 & (cast (cast t) ^ rx);
			if (ry == 0) {
				if (rx == 1) {
					x = s - 1 - x;
					y = s - 1 - y;
				}
				var tmp = x;
				x = y;
				y = tmp;
			}
			x += s * rx;
			y += s * ry;
			t = t / 4;
			s *= 2;
		}
		return new Point(x, y);
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
	
	public function match(o:Point, ?round:Bool):Bool {
		return round 
				? Math.round(o.x) == Math.round(x) && Math.round(o.y) == Math.round(y) 
				: o.x == x && o.y == y;
	}
	
	public function add(q:Point):Point {
		x += q.x;
		y += q.y;
		return this;
	}
	
	public function length():Float {
		return Math.sqrt(x * x + y * y);
	}
	
	public function distanceOf(point:Point):Float {
		return distance(point.x, point.y, x, y);
	}
	
}