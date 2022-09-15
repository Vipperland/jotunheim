<?php
/**
 */

namespace jotun\php\db;

use \php\Boot;

/**
 * ...
 * @author Rafael Moreira
 */
class Limit {
	/**
	 * @var string
	 */
	static public $ONE = "1";

	/**
	 * @param int $i
	 * 
	 * @return string
	 */
	public static function MAX ($i = 1) {
		#src/jotun/php/db/Limit.hx:12: characters 3-23
		if ($i === null) {
			$i = 1;
		}
		#src/jotun/php/db/Limit.hx:12: characters 10-23
		$int = $i;
		#src/jotun/php/db/Limit.hx:12: characters 3-23
		return \Std::string(($int < 0 ? 4294967296.0 + $int : $int + 0.0));
	}

	/**
	 * @param int $i
	 * @param int $len
	 * 
	 * @return string
	 */
	public static function PAGE ($i, $len = 10) {
		#src/jotun/php/db/Limit.hx:16: characters 3-38
		if ($len === null) {
			$len = 10;
		}
		#src/jotun/php/db/Limit.hx:16: characters 10-13
		$tmp = null;
		if ($len === null) {
			$tmp = "null";
		} else {
			$int = $len;
			$tmp = \Std::string(($int < 0 ? 4294967296.0 + $int : $int + 0.0));
		}
		#src/jotun/php/db/Limit.hx:16: characters 29-38
		$tmp1 = $i * $len;
		$tmp2 = null;
		if ($tmp1 === null) {
			$tmp2 = "null";
		} else {
			$int = $tmp1;
			$tmp2 = \Std::string(($int < 0 ? 4294967296.0 + $int : $int + 0.0));
		}
		#src/jotun/php/db/Limit.hx:16: characters 3-38
		return ($tmp??'null') . " offset " . ($tmp2??'null');
	}

	/**
	 * @param int $from
	 * @param int $to
	 * 
	 * @return string
	 */
	public static function SECTION ($from, $to) {
		#src/jotun/php/db/Limit.hx:20: characters 3-19
		$from = Boot::shiftRightUnsigned($from, 0);
		#src/jotun/php/db/Limit.hx:21: characters 3-15
		$to = Boot::shiftRightUnsigned($to, 0);
		#src/jotun/php/db/Limit.hx:22: characters 10-21
		$tmp = $to - $from;
		$tmp1 = null;
		if ($tmp === null) {
			$tmp1 = "null";
		} else {
			$int = $tmp;
			$tmp1 = \Std::string(($int < 0 ? 4294967296.0 + $int : $int + 0.0));
		}
		#src/jotun/php/db/Limit.hx:22: characters 37-41
		$tmp = null;
		if ($from === null) {
			$tmp = "null";
		} else {
			$int = $from;
			$tmp = \Std::string(($int < 0 ? 4294967296.0 + $int : $int + 0.0));
		}
		#src/jotun/php/db/Limit.hx:22: characters 3-41
		return ($tmp1??'null') . " offset " . ($tmp??'null');
	}
}

Boot::registerClass(Limit::class, 'jotun.php.db.Limit');
