<?php
/**
 */

namespace jotun\gaming\actions;

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\tools\Utils;
use \jotun\utils\Dice;
use \php\_Boot\HxString;
use \jotun\objects\Query;

/**
 * ...
 * @author Rim Project
 */
class ActionQuery extends Query {
	/**
	 * @var IEventContext
	 */
	public $ioContext;

	/**
	 *
	 * 
	 * @return void
	 */
	public function __construct () {
		#src/jotun/gaming/actions/ActionQuery.hx:97: characters 3-10
		parent::__construct();
	}

	/**
	 * @param mixed $value
	 * 
	 * @return bool
	 */
	public function _BOOL ($value) {
		#src/jotun/gaming/actions/ActionQuery.hx:32: characters 3-30
		return Utils::boolean($value);
	}

	/**
	 * @param mixed $value
	 * @param float $alt
	 * 
	 * @return float
	 */
	public function _FLOAT ($value, $alt = null) {
		#src/jotun/gaming/actions/ActionQuery.hx:41: characters 3-86
		$o = (is_string($value) ? \Std::parseFloat($value) : (int)($value));
		#src/jotun/gaming/actions/ActionQuery.hx:42: characters 10-29
		if ($o !== null) {
			#src/jotun/gaming/actions/ActionQuery.hx:42: characters 22-23
			return $o;
		} else {
			#src/jotun/gaming/actions/ActionQuery.hx:42: characters 26-29
			return $alt;
		}
	}

	/**
	 * @param mixed $value
	 * @param int $alt
	 * 
	 * @return int
	 */
	public function _INT ($value, $alt = null) {
		#src/jotun/gaming/actions/ActionQuery.hx:36: characters 3-82
		$o = (is_string($value) ? \Std::parseInt($value) : (int)($value));
		#src/jotun/gaming/actions/ActionQuery.hx:37: characters 10-29
		if ($o !== null) {
			#src/jotun/gaming/actions/ActionQuery.hx:37: characters 22-23
			return $o;
		} else {
			#src/jotun/gaming/actions/ActionQuery.hx:37: characters 26-29
			return $alt;
		}
	}

	/**
	 * @param string $value
	 * 
	 * @return mixed
	 */
	public function _PARAMS ($value) {
		#src/jotun/gaming/actions/ActionQuery.hx:18: characters 3-27
		$params = new HxAnon();
		#src/jotun/gaming/actions/ActionQuery.hx:19: lines 19-27
		if ($value !== null) {
			#src/jotun/gaming/actions/ActionQuery.hx:20: characters 4-38
			$value = HxString::split($value, "+")->join(" ");
			#src/jotun/gaming/actions/ActionQuery.hx:21: lines 21-26
			Dice::Values(HxString::split($value, "&"), function ($v) use (&$params) {
				#src/jotun/gaming/actions/ActionQuery.hx:22: characters 5-44
				$data = HxString::split($v, "=");
				#src/jotun/gaming/actions/ActionQuery.hx:23: lines 23-25
				if ($data->length > 1) {
					#src/jotun/gaming/actions/ActionQuery.hx:24: characters 6-48
					\Reflect::setField($params, ($data->arr[0] ?? null), ($data->arr[1] ?? null));
				}
			});
		}
		#src/jotun/gaming/actions/ActionQuery.hx:28: characters 3-16
		return $params;
	}

	/**
	 * @param string $value
	 * 
	 * @return bool
	 */
	public function _isempty ($value) {
		#src/jotun/gaming/actions/ActionQuery.hx:14: characters 10-38
		if ($value !== null) {
			#src/jotun/gaming/actions/ActionQuery.hx:14: characters 27-38
			return $value === "";
		} else {
			#src/jotun/gaming/actions/ActionQuery.hx:14: characters 10-38
			return true;
		}
	}

	/**
	 * @param mixed $a
	 * @param string $r
	 * @param mixed $v
	 * 
	 * @return mixed
	 */
	public function _resolve ($a, $r, $v) {
		#src/jotun/gaming/actions/ActionQuery.hx:50: lines 50-52
		if ($r === null) {
			#src/jotun/gaming/actions/ActionQuery.hx:51: characters 4-11
			$r = "=";
		}
		#src/jotun/gaming/actions/ActionQuery.hx:53: lines 53-88
		if ($r === "!" || $r === "pow") {
			#src/jotun/gaming/actions/ActionQuery.hx:83: characters 21-35
			return ($a ** $v);
		} else if ($r === "#" || $r === "random") {
			#src/jotun/gaming/actions/ActionQuery.hx:85: characters 25-40
			return $this->rng() * $v + $a;
		} else if ($r === "%" || $r === "module") {
			#src/jotun/gaming/actions/ActionQuery.hx:69: characters 24-29
			return fmod($a, $v);
		} else if ($r === "*" || $r === "multiply") {
			#src/jotun/gaming/actions/ActionQuery.hx:65: characters 26-31
			return $a * $v;
		} else if ($r === "++") {
			#src/jotun/gaming/actions/ActionQuery.hx:61: characters 16-21
			return $a + 1;
		} else if ($r === "-" || $r === "minus") {
			#src/jotun/gaming/actions/ActionQuery.hx:59: characters 23-28
			return $a - $v;
		} else if ($r === "--") {
			#src/jotun/gaming/actions/ActionQuery.hx:63: characters 16-21
			return $a - 1;
		} else if ($r === "<<") {
			#src/jotun/gaming/actions/ActionQuery.hx:71: characters 16-22
			return $a << $v;
		} else if ($r === ">>") {
			#src/jotun/gaming/actions/ActionQuery.hx:73: characters 16-22
			return $a >> $v;
		} else if ($r === "^" || $r === "xor") {
			#src/jotun/gaming/actions/ActionQuery.hx:81: characters 21-26
			return $a ^ $v;
		} else if ($r === "&" || $r === "and") {
			#src/jotun/gaming/actions/ActionQuery.hx:79: characters 21-26
			return $a & $v;
		} else if ($r === "/" || $r === "divided") {
			#src/jotun/gaming/actions/ActionQuery.hx:67: characters 25-30
			return $a / $v;
		} else if ($r === "=" || $r === "equal") {
			#src/jotun/gaming/actions/ActionQuery.hx:55: characters 23-24
			return $a;
		} else if ($r === "or" || $r === "|") {
			#src/jotun/gaming/actions/ActionQuery.hx:77: characters 20-25
			return $a | $v;
		} else if ($r === "+" || $r === "plus") {
			#src/jotun/gaming/actions/ActionQuery.hx:57: characters 22-27
			return Boot::addOrConcat($a, $v);
		} else if ($r === "not" || $r === "~") {
			#src/jotun/gaming/actions/ActionQuery.hx:75: characters 21-34
			return $a & ~$v;
		} else {
			#src/jotun/gaming/actions/ActionQuery.hx:87: characters 14-15
			return $a;
		}
	}

	/**
	 * @return float
	 */
	public function rng () {
		#src/jotun/gaming/actions/ActionQuery.hx:46: characters 3-23
		return \mt_rand() / \mt_getrandmax();
	}
}

Boot::registerClass(ActionQuery::class, 'jotun.gaming.actions.ActionQuery');
