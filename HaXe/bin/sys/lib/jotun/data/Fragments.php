<?php
/**
 */

namespace jotun\data;

use \php\Boot;
use \jotun\tools\Utils;
use \php\_Boot\HxString;

/**
 * ...
 * @author Rafael Moreira
 */
class Fragments implements IFragments {
	/**
	 * @var string
	 */
	public $first;
	/**
	 * @var string
	 */
	public $last;
	/**
	 * @var string[]|\Array_hx
	 */
	public $pieces;
	/**
	 * @var string
	 */
	public $value;

	/**
	 * @param string $value
	 * @param string $separator
	 * 
	 * @return void
	 */
	public function __construct ($value, $separator = null) {
		#src/jotun/data/Fragments.hx:29: characters 3-42
		$this->value = ($value === null ? "" : $value);
		#src/jotun/data/Fragments.hx:30: lines 30-31
		if (($separator !== null) && (mb_strlen($separator) > 0)) {
			#src/jotun/data/Fragments.hx:30: characters 50-66
			$this->split($separator);
		} else {
			#src/jotun/data/Fragments.hx:31: characters 8-15
			$this->clear();
		}
	}

	/**
	 * @param int $i
	 * @param int $e
	 * 
	 * @return string
	 */
	public function _sel ($i, $e) {
		#src/jotun/data/Fragments.hx:19: characters 3-28
		$r = new \Array_hx();
		#src/jotun/data/Fragments.hx:20: lines 20-24
		while ($i !== $e) {
			#src/jotun/data/Fragments.hx:21: characters 4-31
			$p = ($this->pieces->arr[$i++] ?? null);
			#src/jotun/data/Fragments.hx:22: lines 22-23
			if (($p !== null) && ($p !== "")) {
				#src/jotun/data/Fragments.hx:23: characters 5-20
				$r->offsetSet($r->length, $p);
			}
		}
		#src/jotun/data/Fragments.hx:25: characters 3-33
		return "/" . ($r->join("/")??'null') . "/";
	}

	/**
	 * @param string $value
	 * @param int $at
	 * 
	 * @return IFragments
	 */
	public function addPiece ($value, $at = -1) {
		#src/jotun/data/Fragments.hx:52: lines 52-63
		if ($at === null) {
			$at = -1;
		}
		#src/jotun/data/Fragments.hx:53: lines 53-61
		if ($at === 0) {
			#src/jotun/data/Fragments.hx:54: characters 4-25
			$_this = $this->pieces;
			$_this->length = \array_unshift($_this->arr, $value);
		} else if (($at === -1) || ($at >= $this->pieces->length)) {
			#src/jotun/data/Fragments.hx:56: characters 4-22
			$_this = $this->pieces;
			$_this->arr[$_this->length++] = $value;
		} else {
			#src/jotun/data/Fragments.hx:58: characters 4-67
			$tail = $this->pieces->splice($at, $this->pieces->length - $at);
			#src/jotun/data/Fragments.hx:59: characters 4-22
			$_this = $this->pieces;
			$_this->arr[$_this->length++] = $value;
			#src/jotun/data/Fragments.hx:60: characters 4-32
			$this->pieces = $this->pieces->concat($tail);
		}
		#src/jotun/data/Fragments.hx:62: characters 3-14
		return $this;
	}

	/**
	 * @return IFragments
	 */
	public function clear () {
		#src/jotun/data/Fragments.hx:77: characters 3-14
		$this->pieces = new \Array_hx();
		#src/jotun/data/Fragments.hx:78: characters 3-13
		$this->first = "";
		#src/jotun/data/Fragments.hx:79: characters 3-12
		$this->last = "";
		#src/jotun/data/Fragments.hx:80: characters 3-14
		return $this;
	}

	/**
	 * @param string $value
	 * 
	 * @return bool
	 */
	public function find ($value) {
		#src/jotun/data/Fragments.hx:44: characters 3-45
		return \Lambda::indexOf($this->pieces, $value) !== -1;
	}

	/**
	 * @param int $i
	 * @param int $e
	 * 
	 * @return string
	 */
	public function get ($i, $e = null) {
		#src/jotun/data/Fragments.hx:66: characters 10-81
		if (($e === null) || ($e <= $i)) {
			#src/jotun/data/Fragments.hx:66: characters 32-68
			if ($i < $this->pieces->length) {
				#src/jotun/data/Fragments.hx:66: characters 53-62
				return ($this->pieces->arr[$i] ?? null);
			} else {
				#src/jotun/data/Fragments.hx:66: characters 65-67
				return "";
			}
		} else {
			#src/jotun/data/Fragments.hx:66: characters 71-81
			return $this->_sel($i, $e);
		}
	}

	/**
	 * @param string $value
	 * 
	 * @return IFragments
	 */
	public function glue ($value) {
		#src/jotun/data/Fragments.hx:48: characters 3-34
		$this->value = $this->pieces->join($value);
		#src/jotun/data/Fragments.hx:49: characters 3-14
		return $this;
	}

	/**
	 * @param int $i
	 * @param string $val
	 * 
	 * @return IFragments
	 */
	public function set ($i, $val) {
		#src/jotun/data/Fragments.hx:70: characters 3-43
		if ($i > $this->pieces->length) {
			#src/jotun/data/Fragments.hx:70: characters 26-43
			$i = $this->pieces->length;
		}
		#src/jotun/data/Fragments.hx:71: lines 71-72
		if ($val !== null) {
			#src/jotun/data/Fragments.hx:72: characters 4-19
			$this->pieces->offsetSet($i, $val);
		}
		#src/jotun/data/Fragments.hx:73: characters 3-14
		return $this;
	}

	/**
	 * @param string $separator
	 * 
	 * @return IFragments
	 */
	public function split ($separator) {
		#src/jotun/data/Fragments.hx:35: characters 3-57
		$this->pieces = Utils::clearArray(HxString::split($this->value, $separator));
		#src/jotun/data/Fragments.hx:36: characters 3-41
		if ($this->pieces->length === 0) {
			#src/jotun/data/Fragments.hx:36: characters 27-41
			$this->pieces->offsetSet(0, "");
		}
		#src/jotun/data/Fragments.hx:37: characters 3-20
		$this->first = ($this->pieces->arr[0] ?? null);
		#src/jotun/data/Fragments.hx:38: characters 3-35
		$this->last = ($this->pieces->arr[$this->pieces->length - 1] ?? null);
		#src/jotun/data/Fragments.hx:39: characters 3-18
		$this->glue($separator);
		#src/jotun/data/Fragments.hx:40: characters 3-14
		return $this;
	}
}

Boot::registerClass(Fragments::class, 'jotun.data.Fragments');
