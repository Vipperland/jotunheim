<?php
/**
 */

namespace jotun\tools;

use \php\Boot;
use \jotun\utils\Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Flag {
	/**
	 * @var int
	 */
	public $value;

	/**
	 * @param int $hash
	 * @param int $bit
	 * 
	 * @return int
	 */
	public static function FDrop ($hash, $bit) {
		#src/jotun/tools/Flag.hx:76: characters 3-21
		return $hash & ~$bit;
	}

	/**
	 * @param int $hash
	 * 
	 * @return int
	 */
	public static function FLength ($hash) {
		#src/jotun/tools/Flag.hx:102: characters 3-22
		$count = 0;
		#src/jotun/tools/Flag.hx:103: lines 103-106
		while (true) {
			#src/jotun/tools/Flag.hx:103: characters 10-16
			$aNeg = $hash < 0;
			$bNeg = false;
			#src/jotun/tools/Flag.hx:103: lines 103-106
			if (!(($aNeg !== $bNeg ? $aNeg : $hash > 0))) {
				break;
			}
			#src/jotun/tools/Flag.hx:104: characters 4-18
			$hash = $hash & ($hash - 1);
			#src/jotun/tools/Flag.hx:105: characters 4-11
			++$count;
		}
		#src/jotun/tools/Flag.hx:107: characters 3-15
		return $count;
	}

	/**
	 * @param int $hash
	 * @param int $bit
	 * 
	 * @return int
	 */
	public static function FPut ($hash, $bit) {
		#src/jotun/tools/Flag.hx:72: characters 3-20
		return $hash | $bit;
	}

	/**
	 * @param int $hash
	 * @param int $value
	 * 
	 * @return bool
	 */
	public static function FTest ($hash, $value) {
		#src/jotun/tools/Flag.hx:84: characters 3-33
		return ($hash & $value) === $value;
	}

	/**
	 * @param int $hash
	 * @param int $bit
	 * 
	 * @return int
	 */
	public static function FToggle ($hash, $bit) {
		#src/jotun/tools/Flag.hx:80: characters 10-63
		if (Flag::FTest($hash, $bit)) {
			#src/jotun/tools/Flag.hx:80: characters 29-45
			return Flag::FDrop($hash, $bit);
		} else {
			#src/jotun/tools/Flag.hx:80: characters 48-63
			return Flag::FPut($hash, $bit);
		}
	}

	/**
	 * @param int $hash
	 * @param int $size
	 * @param int $glen
	 * @param string $glue
	 * 
	 * @return string
	 */
	public static function FValue ($hash, $size = 32, $glen = 8, $glue = " ") {
		#src/jotun/tools/Flag.hx:87: lines 87-99
		if ($size === null) {
			$size = 32;
		}
		if ($glen === null) {
			$glen = 8;
		}
		if ($glue === null) {
			$glue = " ";
		}
		#src/jotun/tools/Flag.hx:88: characters 3-21
		$r = "";
		#src/jotun/tools/Flag.hx:89: characters 3-17
		$g = 0;
		#src/jotun/tools/Flag.hx:90: lines 90-97
		while (true) {
			#src/jotun/tools/Flag.hx:90: characters 9-15
			$aNeg = $size < 0;
			$bNeg = false;
			#src/jotun/tools/Flag.hx:90: lines 90-97
			if (!(($aNeg !== $bNeg ? $aNeg : $size > 0))) {
				break;
			}
			#src/jotun/tools/Flag.hx:91: characters 4-10
			--$size;
			#src/jotun/tools/Flag.hx:92: characters 4-43
			$r = ($r??'null') . ((Flag::FTest($hash, 1 << $size) ? "1" : "0")??'null');
			#src/jotun/tools/Flag.hx:93: lines 93-96
			if (++$g === $glen) {
				#src/jotun/tools/Flag.hx:94: characters 5-10
				$g = 0;
				#src/jotun/tools/Flag.hx:95: characters 5-14
				$r = ($r??'null') . ($glue??'null');
			}
		}
		#src/jotun/tools/Flag.hx:98: characters 3-11
		return $r;
	}

	/**
	 * @param mixed $value
	 * 
	 * @return Flag
	 */
	public static function from ($value) {
		#src/jotun/tools/Flag.hx:65: lines 65-67
		if (is_string($value)) {
			#src/jotun/tools/Flag.hx:66: characters 4-31
			$value = \Std::parseInt($value);
		}
		#src/jotun/tools/Flag.hx:68: characters 3-25
		return new Flag($value);
	}

	/**
	 * @param string $hash
	 * 
	 * @return Flag
	 */
	public static function fromCard ($hash) {
		#src/jotun/tools/Flag.hx:50: characters 3-27
		$hash = Utils::trimm($hash);
		#src/jotun/tools/Flag.hx:51: characters 3-27
		$i = mb_strlen($hash);
		#src/jotun/tools/Flag.hx:52: characters 3-17
		$r = 0;
		#src/jotun/tools/Flag.hx:53: characters 3-13
		$f = null;
		#src/jotun/tools/Flag.hx:54: lines 54-60
		while ($i > 0) {
			#src/jotun/tools/Flag.hx:55: characters 4-7
			--$i;
			#src/jotun/tools/Flag.hx:56: characters 4-39
			$f = \Std::parseInt(\mb_substr($hash, $i, 1));
			#src/jotun/tools/Flag.hx:57: lines 57-59
			if ($f > 0) {
				#src/jotun/tools/Flag.hx:58: characters 5-21
				$r |= 1 << $i;
			}
		}
		#src/jotun/tools/Flag.hx:61: characters 3-21
		return new Flag($r);
	}

	/**
	 * @param int $value
	 * 
	 * @return void
	 */
	public function __construct ($value) {
		#src/jotun/tools/Flag.hx:113: characters 3-27
		$this->value = Boot::shiftRightUnsigned($value, 0);
	}

	/**
	 * @param int $bit
	 * 
	 * @return Flag
	 */
	public function drop ($bit) {
		#src/jotun/tools/Flag.hx:127: characters 3-31
		$this->value = Flag::FDrop($this->value, 1 << $bit);
		#src/jotun/tools/Flag.hx:128: characters 3-14
		return $this;
	}

	/**
	 * @param int[]|\Array_hx $bits
	 * 
	 * @return Flag
	 */
	public function dropAll ($bits) {
		#src/jotun/tools/Flag.hx:142: lines 142-147
		$_gthis = $this;
		#src/jotun/tools/Flag.hx:143: lines 143-145
		Dice::Values($bits, function ($v) use (&$_gthis) {
			#src/jotun/tools/Flag.hx:144: characters 4-14
			$_gthis->drop(1 << $v);
		});
		#src/jotun/tools/Flag.hx:146: characters 3-14
		return $this;
	}

	/**
	 * @return int
	 */
	public function length () {
		#src/jotun/tools/Flag.hx:165: characters 3-24
		return Flag::FLength($this->value);
	}

	/**
	 * @param int $bit
	 * 
	 * @return Flag
	 */
	public function put ($bit) {
		#src/jotun/tools/Flag.hx:122: characters 3-30
		$this->value = Flag::FPut($this->value, 1 << $bit);
		#src/jotun/tools/Flag.hx:123: characters 3-14
		return $this;
	}

	/**
	 * @param int[]|\Array_hx $bits
	 * 
	 * @return Flag
	 */
	public function putAll ($bits) {
		#src/jotun/tools/Flag.hx:135: lines 135-140
		$_gthis = $this;
		#src/jotun/tools/Flag.hx:136: lines 136-138
		Dice::Values($bits, function ($v) use (&$_gthis) {
			#src/jotun/tools/Flag.hx:137: characters 4-13
			$_gthis->put(1 << $v);
		});
		#src/jotun/tools/Flag.hx:139: characters 3-14
		return $this;
	}

	/**
	 * @param int $bit
	 * 
	 * @return bool
	 */
	public function test ($bit) {
		#src/jotun/tools/Flag.hx:132: characters 3-30
		return Flag::FTest($this->value, 1 << $bit);
	}

	/**
	 * @param int[]|\Array_hx $bits
	 * 
	 * @return bool
	 */
	public function testAll ($bits) {
		#src/jotun/tools/Flag.hx:149: lines 149-153
		$_gthis = $this;
		#src/jotun/tools/Flag.hx:150: lines 150-152
		return Dice::Values($bits, function ($v) use (&$_gthis) {
			#src/jotun/tools/Flag.hx:151: characters 4-19
			return !$_gthis->test($v);
		})->completed;
	}

	/**
	 * @param int[]|\Array_hx $bits
	 * @param int $min
	 * 
	 * @return bool
	 */
	public function testAny ($bits, $min = 1) {
		#src/jotun/tools/Flag.hx:155: lines 155-162
		if ($min === null) {
			$min = 1;
		}
		$_gthis = $this;
		#src/jotun/tools/Flag.hx:156: lines 156-161
		return !Dice::Values($bits, function ($v) use (&$min, &$_gthis) {
			#src/jotun/tools/Flag.hx:157: lines 157-159
			if ($_gthis->test($v)) {
				#src/jotun/tools/Flag.hx:158: characters 5-10
				$min -= 1;
			}
			#src/jotun/tools/Flag.hx:160: characters 4-19
			return $min === 0;
		})->completed;
	}

	/**
	 * @param int $size
	 * @param int $glen
	 * 
	 * @return string
	 */
	public function toCard ($size = 32, $glen = 8) {
		#src/jotun/tools/Flag.hx:173: characters 3-41
		if ($size === null) {
			$size = 32;
		}
		if ($glen === null) {
			$glen = 8;
		}
		return Flag::FValue($this->value, $size, $glen, "\x0A");
	}

	/**
	 * @param int $size
	 * @param int $glen
	 * 
	 * @return string
	 */
	public function toString ($size = 32, $glen = 8) {
		#src/jotun/tools/Flag.hx:169: characters 3-40
		if ($size === null) {
			$size = 32;
		}
		if ($glen === null) {
			$glen = 8;
		}
		return Flag::FValue($this->value, $size, $glen, " ");
	}

	/**
	 * @param int $bit
	 * 
	 * @return Flag
	 */
	public function toggle ($bit) {
		#src/jotun/tools/Flag.hx:117: characters 3-30
		$this->value = Flag::FToggle($this->value, $bit);
		#src/jotun/tools/Flag.hx:118: characters 3-14
		return $this;
	}

	public function __toString() {
		return $this->toString();
	}
}

Boot::registerClass(Flag::class, 'jotun.tools.Flag');
