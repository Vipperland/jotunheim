<?php
/**
 */

namespace jotun\tools;

use \php\_Boot\HxDynamicStr;
use \php\Boot;
use \jotun\utils\Dice;

/**
 * ...
 * @author Rim Project
 */
class LoFlag {
	/**
	 * @var int[]|\Array_hx
	 */
	public $_flags;

	/**
	 * @param string $value
	 * 
	 * @return LoFlag
	 */
	public static function fromString ($value) {
		#src/jotun/tools/LoFlag.hx:11: characters 3-37
		return (new LoFlag(0))->load($value);
	}

	/**
	 * @param int[]|\Array_hx $data
	 * 
	 * @return LoFlag
	 */
	public static function fromVect ($data) {
		#src/jotun/tools/LoFlag.hx:15: characters 3-32
		$f = new LoFlag(0);
		#src/jotun/tools/LoFlag.hx:16: characters 3-18
		$f->_flags = $data;
		#src/jotun/tools/LoFlag.hx:17: characters 3-11
		return $f;
	}

	/**
	 * @param int $size
	 * 
	 * @return void
	 */
	public function __construct ($size = 32) {
		#src/jotun/tools/LoFlag.hx:28: lines 28-33
		if ($size === null) {
			$size = 32;
		}
		#src/jotun/tools/LoFlag.hx:29: characters 3-14
		$this->_flags = new \Array_hx();
		#src/jotun/tools/LoFlag.hx:30: lines 30-32
		if (--$size > 0) {
			#src/jotun/tools/LoFlag.hx:31: characters 4-30
			$this->_fit((int)(\ceil($size / 32)));
		}
	}

	/**
	 * @param int $length
	 * 
	 * @return void
	 */
	public function _fit ($length) {
		#src/jotun/tools/LoFlag.hx:23: lines 23-25
		while ($this->_flags->length < $length) {
			#src/jotun/tools/LoFlag.hx:24: characters 4-29
			$this->_flags->offsetSet($this->_flags->length, 0);
		}
	}

	/**
	 * @param int $i
	 * 
	 * @return LoFlag
	 */
	public function drop ($i) {
		#src/jotun/tools/LoFlag.hx:58: characters 3-31
		$b = (int)(($i / 32));
		#src/jotun/tools/LoFlag.hx:59: characters 3-39
		$o = ($this->_flags->arr[$b] ?? null) | ~(1 << ($i % 32));
		#src/jotun/tools/LoFlag.hx:60: characters 3-14
		return $this;
	}

	/**
	 * @return int[]|\Array_hx
	 */
	public function flags () {
		#src/jotun/tools/LoFlag.hx:70: characters 3-16
		return $this->_flags;
	}

	/**
	 * @param int $i
	 * 
	 * @return bool
	 */
	public function get ($i) {
		#src/jotun/tools/LoFlag.hx:64: characters 3-31
		$b = (int)(($i / 32));
		#src/jotun/tools/LoFlag.hx:65: characters 3-22
		$i = 1 << ($i % 32);
		#src/jotun/tools/LoFlag.hx:66: characters 3-28
		return (($this->_flags->arr[$b] ?? null) & $i) === $i;
	}

	/**
	 * @param mixed $data
	 * 
	 * @return LoFlag
	 */
	public function load ($data) {
		#src/jotun/tools/LoFlag.hx:35: lines 35-44
		$_gthis = $this;
		#src/jotun/tools/LoFlag.hx:36: lines 36-42
		if (is_string($data)) {
			#src/jotun/tools/LoFlag.hx:37: lines 37-39
			Dice::All(HxDynamicStr::wrap($data)->split("-"), function ($p, $v) use (&$_gthis) {
				#src/jotun/tools/LoFlag.hx:38: characters 5-44
				$_gthis->_flags->offsetSet($_gthis->_flags->length, \Std::parseInt($v));
			});
		} else if (($data instanceof \Array_hx)) {
			#src/jotun/tools/LoFlag.hx:41: characters 4-17
			$this->_flags = $data;
		}
		#src/jotun/tools/LoFlag.hx:43: characters 3-14
		return $this;
	}

	/**
	 * @param int $i
	 * 
	 * @return LoFlag
	 */
	public function put ($i) {
		#src/jotun/tools/LoFlag.hx:52: characters 3-31
		$b = (int)(($i / 32));
		#src/jotun/tools/LoFlag.hx:53: characters 3-38
		$o = ($this->_flags->arr[$b] ?? null) | (1 << ($i % 32));
		#src/jotun/tools/LoFlag.hx:54: characters 3-14
		return $this;
	}

	/**
	 * @param int $block
	 * @param int $flags
	 * 
	 * @return LoFlag
	 */
	public function set ($block, $flags) {
		#src/jotun/tools/LoFlag.hx:47: characters 3-24
		$this->_flags->offsetSet($block, $flags);
		#src/jotun/tools/LoFlag.hx:48: characters 3-14
		return $this;
	}

	/**
	 * @return string
	 */
	public function toString () {
		#src/jotun/tools/LoFlag.hx:74: characters 3-26
		return $this->_flags->join("-");
	}

	public function __toString() {
		return $this->toString();
	}
}

Boot::registerClass(LoFlag::class, 'jotun.tools.LoFlag');
