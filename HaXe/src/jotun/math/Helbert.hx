package jotun.math;

/**
 * ...
 * @author Rafael Moreira
 */
class Helbert {

	static public function get(n:Int, d:Int):Point {
		var rx:Int;
		var ry:Int;
		var t:Int = d;
		var x:Int = 0;
		var y:Int = 0;
		for (var s = 1; s < n; s *= 2) {
			rx = 1 & (t / 2);
			ry = 1 & (t ^ rx);
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
			t /= 4;
		}
		return new Point(x, y);
	}
	
}