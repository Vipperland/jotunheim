<?php
/**
 */

namespace jotun\math;

use \php\Boot;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Point {
	/**
	 * @var float
	 */
	public $x;
	/**
	 * @var float
	 */
	public $y;

	/**
	 * @param float $x1
	 * @param float $y1
	 * @param float $x2
	 * @param float $y2
	 * 
	 * @return float
	 */
	public static function distance ($x1, $y1, $x2, $y2) {
		#src/jotun/math/Point.hx:11: characters 3-17
		$x1 -= $x2;
		#src/jotun/math/Point.hx:12: characters 3-17
		$y1 -= $y2;
		#src/jotun/math/Point.hx:13: characters 3-15
		$x1 *= $x1;
		#src/jotun/math/Point.hx:14: characters 3-15
		$y1 *= $y1;
		#src/jotun/math/Point.hx:15: characters 3-28
		return \sqrt($x1 + $y1);
	}

	/**
	 * @param int $n
	 * @param int $d
	 * 
	 * @return Point
	 */
	public static function hilbert ($n, $d) {
		#src/jotun/math/Point.hx:19: characters 3-14
		$rx = null;
		#src/jotun/math/Point.hx:20: characters 3-14
		$ry = null;
		#src/jotun/math/Point.hx:21: characters 3-19
		$t = $d;
		#src/jotun/math/Point.hx:22: characters 3-17
		$x = 0;
		#src/jotun/math/Point.hx:23: characters 3-17
		$y = 0;
		#src/jotun/math/Point.hx:24: characters 3-17
		$s = 0;
		#src/jotun/math/Point.hx:25: lines 25-41
		while ($s < $n) {
			#src/jotun/math/Point.hx:26: characters 4-32
			$rx = 1 & ($t / 2);
			#src/jotun/math/Point.hx:27: characters 4-33
			$ry = 1 & ($t ^ $rx);
			#src/jotun/math/Point.hx:28: lines 28-36
			if ($ry === 0) {
				#src/jotun/math/Point.hx:29: lines 29-32
				if ($rx === 1) {
					#src/jotun/math/Point.hx:30: characters 6-19
					$x = $s - 1 - $x;
					#src/jotun/math/Point.hx:31: characters 6-19
					$y = $s - 1 - $y;
				}
				#src/jotun/math/Point.hx:33: characters 5-17
				$tmp = $x;
				#src/jotun/math/Point.hx:34: characters 5-10
				$x = $y;
				#src/jotun/math/Point.hx:35: characters 5-12
				$y = $tmp;
			}
			#src/jotun/math/Point.hx:37: characters 4-15
			$x += $s * $rx;
			#src/jotun/math/Point.hx:38: characters 4-15
			$y += $s * $ry;
			#src/jotun/math/Point.hx:39: characters 4-13
			$t /= 4;
			#src/jotun/math/Point.hx:40: characters 4-10
			$s *= 2;
		}
		#src/jotun/math/Point.hx:42: characters 3-25
		return new Point($x, $y);
	}

	/**
	 * @param float $x
	 * @param float $y
	 * 
	 * @return void
	 */
	public function __construct ($x, $y) {
		#src/jotun/math/Point.hx:50: characters 3-13
		$this->x = $x;
		#src/jotun/math/Point.hx:51: characters 3-13
		$this->y = $y;
	}

	/**
	 * @param Point $q
	 * 
	 * @return Point
	 */
	public function add ($q) {
		#src/jotun/math/Point.hx:65: characters 3-11
		$this->x += $q->x;
		#src/jotun/math/Point.hx:66: characters 3-11
		$this->y += $q->y;
		#src/jotun/math/Point.hx:67: characters 3-14
		return $this;
	}

	/**
	 * @param Point $point
	 * 
	 * @return float
	 */
	public function distanceOf ($point) {
		#src/jotun/math/Point.hx:75: characters 3-42
		return Point::distance($point->x, $point->y, $this->x, $this->y);
	}

	/**
	 * @return float
	 */
	public function length () {
		#src/jotun/math/Point.hx:71: characters 10-34
		return \sqrt($this->x * $this->x + $this->y * $this->y);
	}

	/**
	 * @param Point $o
	 * @param bool $round
	 * 
	 * @return bool
	 */
	public function match ($o, $round = null) {
		#src/jotun/math/Point.hx:59: lines 59-61
		if ($round) {
			#src/jotun/math/Point.hx:60: characters 7-75
			if ((int)(\floor($o->x + 0.5)) === (int)(\floor($this->x + 0.5))) {
				#src/jotun/math/Point.hx:60: characters 43-75
				return (int)(\floor($o->y + 0.5)) === (int)(\floor($this->y + 0.5));
			} else {
				#src/jotun/math/Point.hx:60: characters 7-75
				return false;
			}
		} else if (Boot::equal($o->x, $this->x)) {
			#src/jotun/math/Point.hx:61: characters 19-27
			return Boot::equal($o->y, $this->y);
		} else {
			#src/jotun/math/Point.hx:61: characters 7-27
			return false;
		}
	}

	/**
	 * @return void
	 */
	public function reset () {
		#src/jotun/math/Point.hx:55: characters 3-12
		$this->x = $this->y = 0;
	}
}

Boot::registerClass(Point::class, 'jotun.math.Point');
