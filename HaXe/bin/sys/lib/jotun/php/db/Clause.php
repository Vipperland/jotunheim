<?php
/**
 */

namespace jotun\php\db;

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\utils\Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Clause {
	/**
	 * @var string
	 */
	public $_joiner;
	/**
	 * @var mixed
	 * Inner conditions
	 */
	public $conditions;

	/**
	 * Group by entries by (A && B && ... && N)
	 * @param	conditions
	 * @return
	 * 
	 * @param mixed[]|\Array_hx $conditions
	 * 
	 * @return Clause
	 */
	public static function AND ($conditions) {
		#src/jotun/php/db/Clause.hx:42: characters 3-40
		return new Clause($conditions, " && ");
	}

	/**
	 * IF A>=B && A<=C
	 * @param	param
	 * @param	from
	 * @param	to
	 * @return
	 * 
	 * @param string $param
	 * @param int $from
	 * @param int $to
	 * 
	 * @return mixed
	 */
	public static function BETWEEN ($param, $from, $to) {
		#src/jotun/php/db/Clause.hx:245: characters 3-76
		return new _HxAnon_Clause0($param, "{{p}} BETWEEN ? AND ?", \Array_hx::wrap([
			$from,
			$to,
		]));
	}

	/**
	 * IF A&B
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param int $value
	 * 
	 * @return mixed
	 */
	public static function BIT ($param, $value) {
		#src/jotun/php/db/Clause.hx:279: characters 3-61
		return new _HxAnon_Clause0($param, "{{p}} & ?", $value);
	}

	/**
	 * IF A&~B
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param int $value
	 * 
	 * @return mixed
	 */
	public static function BIT_NOT ($param, $value) {
		#src/jotun/php/db/Clause.hx:289: characters 3-62
		return new _HxAnon_Clause0($param, "~{{p}} & ?", $value);
	}

	/**
	 * Add a custom condition
	 * @param	condition
	 * @return
	 * 
	 * @param string $condition
	 * 
	 * @return mixed
	 */
	public static function CUSTOM ($condition) {
		#src/jotun/php/db/Clause.hx:100: characters 3-66
		return new _HxAnon_Clause1("", $condition, null, true);
	}

	/**
	 * IF A!=B
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function DIFF ($param, $value) {
		#src/jotun/php/db/Clause.hx:190: characters 3-60
		return new _HxAnon_Clause0($param, "{{p}}!=?", $value);
	}

	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function DIFFERENT ($param, $value) {
		#src/jotun/php/db/Clause.hx:91: characters 3-60
		return new _HxAnon_Clause0($param, "{{p}}!=?", $value);
	}

	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function EQUAL ($param, $value) {
		#src/jotun/php/db/Clause.hx:81: characters 3-59
		return new _HxAnon_Clause0($param, "{{p}}=?", $value);
	}

	/**
	 * IF A=0
	 * @param	param
	 * @return
	 * 
	 * @param string $param
	 * 
	 * @return mixed
	 */
	public static function FALSE ($param) {
		#src/jotun/php/db/Clause.hx:180: characters 3-59
		return new _HxAnon_Clause0($param, "{{p}}=?", false);
	}

	/**
	 * IF A|1 AND A|2 AND A|...N [NEED ALL]
	 * @param	param
	 * @param	flags
	 * @param	any		IF A|1 OR A|2 OR A|...N [NEED ANY]
	 * @return
	 * 
	 * @param string $param
	 * @param int[]|\Array_hx $flags
	 * @param bool $any
	 * 
	 * @return Clause
	 */
	public static function FLAGS ($param, $flags, $any = false) {
		#src/jotun/php/db/Clause.hx:266: lines 266-270
		if ($any === null) {
			$any = false;
		}
		#src/jotun/php/db/Clause.hx:267: characters 3-29
		$a = new \Array_hx();
		#src/jotun/php/db/Clause.hx:268: characters 3-84
		Dice::Values($flags, function ($v) use (&$param, &$a) {
			#src/jotun/php/db/Clause.hx:268: characters 46-80
			$a->offsetSet($a->length, Clause::BIT($param, $v));
		});
		#src/jotun/php/db/Clause.hx:269: characters 10-44
		if ($any) {
			#src/jotun/php/db/Clause.hx:269: characters 16-28
			return Clause::OR($a);
		} else {
			#src/jotun/php/db/Clause.hx:269: characters 31-44
			return Clause::AND($a);
		}
	}

	/**
	 * IF A>B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function GREATER ($param, $value) {
		#src/jotun/php/db/Clause.hx:223: characters 3-59
		return new _HxAnon_Clause0($param, "{{p}}>?", $value);
	}

	/**
	 * IF A>B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function GREATER_OR ($param, $value) {
		#src/jotun/php/db/Clause.hx:234: characters 3-60
		return new _HxAnon_Clause0($param, "{{p}}>=?", $value);
	}

	/**
	 * IF id=A
	 * @param	value
	 * @return
	 * 
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function ID ($value) {
		#src/jotun/php/db/Clause.hx:71: characters 3-58
		return new _HxAnon_Clause0("id", "{{p}}=?", $value);
	}

	/**
	 * IF A In (B,B,...)
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $values
	 * 
	 * @return mixed
	 */
	public static function IN ($param, $values) {
		#src/jotun/php/db/Clause.hx:130: lines 130-136
		if (($values instanceof \Array_hx)) {
			#src/jotun/php/db/Clause.hx:131: characters 4-29
			$q = new \Array_hx();
			#src/jotun/php/db/Clause.hx:132: characters 4-73
			Dice::All($values, function ($p, $v) use (&$q) {
				#src/jotun/php/db/Clause.hx:132: characters 52-69
				$q->offsetSet($q->length, "?");
			});
			#src/jotun/php/db/Clause.hx:133: characters 4-84
			return new _HxAnon_Clause0($param, "{{p}} IN (" . ($q->join(",")??'null') . ")", $values);
		} else {
			#src/jotun/php/db/Clause.hx:135: characters 4-66
			return new _HxAnon_Clause0($param, "{{p}} IN (?)", $values);
		}
	}

	/**
	 * If A contains B
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * 
	 * @return mixed
	 */
	public static function IS_NULL ($param) {
		#src/jotun/php/db/Clause.hx:110: characters 3-75
		return new _HxAnon_Clause1($param, "{{p}} IS NULL", null, true);
	}

	/**
	 * IF A<[=]B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function LESS ($param, $value) {
		#src/jotun/php/db/Clause.hx:201: characters 3-59
		return new _HxAnon_Clause0($param, "{{p}}<?", $value);
	}

	/**
	 * IF A<=B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function LESS_OR ($param, $value) {
		#src/jotun/php/db/Clause.hx:212: characters 3-60
		return new _HxAnon_Clause0($param, "{{p}}<=?", $value);
	}

	/**
	 * If A contains B
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function LIKE ($param, $value) {
		#src/jotun/php/db/Clause.hx:52: characters 3-64
		return new _HxAnon_Clause0($param, "{{p}} LIKE ?", $value);
	}

	/**
	 * IF A<=B && A>=C
	 * @param	param
	 * @param	from
	 * @param	to
	 * @return
	 * 
	 * @param string $param
	 * @param int $from
	 * @param int $to
	 * 
	 * @return mixed
	 */
	public static function NOT_BETWEEN ($param, $from, $to) {
		#src/jotun/php/db/Clause.hx:256: characters 3-80
		return new _HxAnon_Clause0($param, "{{p}} NOT BETWEEN ? AND ?", \Array_hx::wrap([
			$from,
			$to,
		]));
	}

	/**
	 * IF A NOT IN (B,B,...))
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $values
	 * 
	 * @return mixed
	 */
	public static function NOT_IN ($param, $values) {
		#src/jotun/php/db/Clause.hx:146: lines 146-152
		if (($values instanceof \Array_hx)) {
			#src/jotun/php/db/Clause.hx:147: characters 4-29
			$q = new \Array_hx();
			#src/jotun/php/db/Clause.hx:148: characters 4-73
			Dice::All($values, function ($p, $v) use (&$q) {
				#src/jotun/php/db/Clause.hx:148: characters 52-69
				$q->offsetSet($q->length, "?");
			});
			#src/jotun/php/db/Clause.hx:149: characters 4-88
			return new _HxAnon_Clause0($param, "{{p}} NOT IN (" . ($q->join(",")??'null') . ")", $values);
		} else {
			#src/jotun/php/db/Clause.hx:151: characters 4-70
			return new _HxAnon_Clause0($param, "{{p}} NOT IN (?)", $values);
		}
	}

	/**
	 * IF B not in A
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function NOT_LIKE ($param, $value) {
		#src/jotun/php/db/Clause.hx:62: characters 3-68
		return new _HxAnon_Clause0($param, "{{p}} NOT LIKE ?", $value);
	}

	/**
	 * If A contains B
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * 
	 * @return mixed
	 */
	public static function NOT_NULL ($param) {
		#src/jotun/php/db/Clause.hx:120: characters 3-75
		return new _HxAnon_Clause1($param, "{{p}} != NULL", null, true);
	}

	/**
	 * Group by entries by (A || B || ... || N)
	 * @param	conditions
	 * @return
	 * 
	 * @param mixed[]|\Array_hx $conditions
	 * 
	 * @return Clause
	 */
	public static function OR ($conditions) {
		#src/jotun/php/db/Clause.hx:33: characters 3-40
		return new Clause($conditions, " || ");
	}

	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 * 
	 * @param string $param
	 * @param mixed $value
	 * 
	 * @return mixed
	 */
	public static function REGEXP ($param, $value) {
		#src/jotun/php/db/Clause.hx:162: characters 3-66
		return new _HxAnon_Clause0($param, "{{p}} REGEXP ?", $value);
	}

	/**
	 * IF A=1
	 * @param	param
	 * @return
	 * 
	 * @param string $param
	 * 
	 * @return mixed
	 */
	public static function TRUE ($param) {
		#src/jotun/php/db/Clause.hx:171: characters 3-58
		return new _HxAnon_Clause0($param, "{{p}}=?", true);
	}

	/**
	 *
	 * @param	conditions
	 * @param	joiner
	 * 
	 * @param mixed $conditions
	 * @param string $joiner
	 * 
	 * @return void
	 */
	public function __construct ($conditions, $joiner) {
		#src/jotun/php/db/Clause.hx:23: characters 3-19
		$this->_joiner = $joiner;
		#src/jotun/php/db/Clause.hx:24: characters 3-31
		$this->conditions = $conditions;
	}

	/**
	 *
	 * @return
	 * 
	 * @return string
	 */
	public function joiner () {
		#src/jotun/php/db/Clause.hx:297: characters 3-17
		return $this->_joiner;
	}
}

class _HxAnon_Clause0 extends HxAnon {
	function __construct($param, $condition, $value) {
		$this->param = $param;
		$this->condition = $condition;
		$this->value = $value;
	}
}

class _HxAnon_Clause1 extends HxAnon {
	function __construct($param, $condition, $value, $skip) {
		$this->param = $param;
		$this->condition = $condition;
		$this->value = $value;
		$this->skip = $skip;
	}
}

Boot::registerClass(Clause::class, 'jotun.php.db.Clause');
