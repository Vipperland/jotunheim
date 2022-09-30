<?php
/**
 */

namespace jotun\gaming\actions;

use \php\_Boot\HxDynamicStr;
use \php\Boot;
use \jotun\objects\Query;

/**
 * ...
 * @author Rim Project
 */
class RequirementQuery extends Query {
	/**
	 * @var IEventContext
	 */
	public $ioContext;

	/**
	 * @return void
	 */
	public function __construct () {
		#src/jotun/gaming/actions/RequirementQuery.hx:71: characters 3-10
		parent::__construct();
	}

	/**
	 * @param mixed $value
	 * @param float $alt
	 * 
	 * @return float
	 */
	public function _FLOAT ($value, $alt) {
		#src/jotun/gaming/actions/RequirementQuery.hx:22: characters 3-86
		$o = (is_string($value) ? \Std::parseFloat($value) : (int)($value));
		#src/jotun/gaming/actions/RequirementQuery.hx:23: characters 10-29
		if ($o !== null) {
			#src/jotun/gaming/actions/RequirementQuery.hx:23: characters 22-23
			return $o;
		} else {
			#src/jotun/gaming/actions/RequirementQuery.hx:23: characters 26-29
			return $alt;
		}
	}

	/**
	 * @param mixed $value
	 * @param int $alt
	 * 
	 * @return int
	 */
	public function _INT ($value, $alt) {
		#src/jotun/gaming/actions/RequirementQuery.hx:17: characters 3-82
		$o = (is_string($value) ? \Std::parseInt($value) : (int)($value));
		#src/jotun/gaming/actions/RequirementQuery.hx:18: characters 10-29
		if ($o !== null) {
			#src/jotun/gaming/actions/RequirementQuery.hx:18: characters 22-23
			return $o;
		} else {
			#src/jotun/gaming/actions/RequirementQuery.hx:18: characters 26-29
			return $alt;
		}
	}

	/**
	 * @param string $value
	 * 
	 * @return bool
	 */
	public function _isempty ($value) {
		#src/jotun/gaming/actions/RequirementQuery.hx:13: characters 10-38
		if ($value !== null) {
			#src/jotun/gaming/actions/RequirementQuery.hx:13: characters 27-38
			return $value === "";
		} else {
			#src/jotun/gaming/actions/RequirementQuery.hx:13: characters 10-38
			return true;
		}
	}

	/**
	 * @param mixed $a
	 * @param string $r
	 * @param mixed $v
	 * 
	 * @return bool
	 */
	public function _resolve ($a, $r, $v) {
		#src/jotun/gaming/actions/RequirementQuery.hx:31: lines 31-33
		if ($r === null) {
			#src/jotun/gaming/actions/RequirementQuery.hx:32: characters 4-12
			$r = ">=";
		}
		#src/jotun/gaming/actions/RequirementQuery.hx:34: lines 34-65
		if ($r === "!&" || $r === "not") {
			#src/jotun/gaming/actions/RequirementQuery.hx:50: characters 21-34
			return Boot::equal((~$a & $v), $v);
		} else if ($r === "!=" || $r === "diff") {
			#src/jotun/gaming/actions/RequirementQuery.hx:38: characters 23-29
			return !Boot::equal($a, $v);
		} else if ($r === "#<" || $r === "rngless") {
			#src/jotun/gaming/actions/RequirementQuery.hx:62: characters 26-42
			return ($this->rng() * $a) <= $v;
		} else if ($r === "#=" || $r === "random") {
			#src/jotun/gaming/actions/RequirementQuery.hx:56: characters 25-55
			return Boot::equal((int)(($this->rng() * $a)), $v);
		} else if ($r === "*=" || $r === "contain") {
			#src/jotun/gaming/actions/RequirementQuery.hx:52: characters 26-44
			return !Boot::equal(HxDynamicStr::wrap($a)->indexOf($v), -1);
		} else if ($r === "<" || $r === "less") {
			#src/jotun/gaming/actions/RequirementQuery.hx:40: characters 22-27
			return $a < $v;
		} else if ($r === "=" || $r === "equal") {
			#src/jotun/gaming/actions/RequirementQuery.hx:36: characters 23-29
			return Boot::equal($a, $v);
		} else if ($r === ">" || $r === "great") {
			#src/jotun/gaming/actions/RequirementQuery.hx:44: characters 22-27
			return $a > $v;
		} else if ($r === ">=" || $r === "greator") {
			#src/jotun/gaming/actions/RequirementQuery.hx:46: characters 26-32
			return $a >= $v;
		} else if ($r === "<=" || $r === "lessor") {
			#src/jotun/gaming/actions/RequirementQuery.hx:42: characters 25-31
			return $a <= $v;
		} else if ($r === "#>" || $r === "rnggreat") {
			#src/jotun/gaming/actions/RequirementQuery.hx:60: characters 27-43
			return ($this->rng() * $a) >= $v;
		} else if ($r === "#!" || $r === "rngnot") {
			#src/jotun/gaming/actions/RequirementQuery.hx:58: characters 25-55
			return !Boot::equal((int)(($this->rng() * $a)), $v);
		} else if ($r === "&" || $r === "test") {
			#src/jotun/gaming/actions/RequirementQuery.hx:48: characters 22-34
			return Boot::equal(($a & $v), $v);
		} else if ($r === "in" || $r === "~=") {
			#src/jotun/gaming/actions/RequirementQuery.hx:54: characters 21-39
			return !Boot::equal(HxDynamicStr::wrap($v)->indexOf($a), -1);
		} else {
			#src/jotun/gaming/actions/RequirementQuery.hx:64: characters 14-20
			return Boot::equal($a, $v);
		}
	}

	/**
	 * @return float
	 */
	public function rng () {
		#src/jotun/gaming/actions/RequirementQuery.hx:27: characters 3-23
		return \mt_rand() / \mt_getrandmax();
	}
}

Boot::registerClass(RequirementQuery::class, 'jotun.gaming.actions.RequirementQuery');
