<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace jotun\logical;

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\tools\Utils;
use \jotun\utils\Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Flag {
	/**
	 * @var int[]|\Array_hx
	 */
	static public $_bits;

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
		#src/jotun/logical/Flag.hx:81: characters 3-21
		return $hash & ~$bit;
	}

	/**
	 * @param int $hash
	 * 
	 * @return int
	 */
	public static function FLength ($hash) {
		#src/jotun/logical/Flag.hx:107: characters 3-22
		$count = 0;
		#src/jotun/logical/Flag.hx:108: lines 108-111
		while (true) {
			#src/jotun/logical/Flag.hx:108: characters 10-16
			$aNeg = $hash < 0;
			$bNeg = false;
			#src/jotun/logical/Flag.hx:108: lines 108-111
			if (!(($aNeg !== $bNeg ? $aNeg : $hash > 0))) {
				break;
			}
			#src/jotun/logical/Flag.hx:109: characters 4-18
			$hash = $hash & ($hash - 1);
			#src/jotun/logical/Flag.hx:110: characters 4-11
			++$count;
		}
		#src/jotun/logical/Flag.hx:112: characters 3-15
		return $count;
	}

	/**
	 * @param int $hash
	 * @param int $bit
	 * 
	 * @return int
	 */
	public static function FPut ($hash, $bit) {
		#src/jotun/logical/Flag.hx:77: characters 3-20
		return $hash | $bit;
	}

	/**
	 * @param int $hash
	 * @param int $value
	 * 
	 * @return bool
	 */
	public static function FTest ($hash, $value) {
		#src/jotun/logical/Flag.hx:89: characters 3-33
		return ($hash & $value) === $value;
	}

	/**
	 * @param int $hash
	 * @param int $bit
	 * 
	 * @return int
	 */
	public static function FToggle ($hash, $bit) {
		#src/jotun/logical/Flag.hx:85: characters 10-63
		if (Flag::FTest($hash, $bit)) {
			#src/jotun/logical/Flag.hx:85: characters 29-45
			return Flag::FDrop($hash, $bit);
		} else {
			#src/jotun/logical/Flag.hx:85: characters 48-63
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
		#src/jotun/logical/Flag.hx:92: lines 92-104
		if ($size === null) {
			$size = 32;
		}
		if ($glen === null) {
			$glen = 8;
		}
		if ($glue === null) {
			$glue = " ";
		}
		#src/jotun/logical/Flag.hx:93: characters 3-21
		$r = "";
		#src/jotun/logical/Flag.hx:94: characters 3-17
		$g = 0;
		#src/jotun/logical/Flag.hx:95: lines 95-102
		while (true) {
			#src/jotun/logical/Flag.hx:95: characters 9-15
			$aNeg = $size < 0;
			$bNeg = false;
			#src/jotun/logical/Flag.hx:95: lines 95-102
			if (!(($aNeg !== $bNeg ? $aNeg : $size > 0))) {
				break;
			}
			#src/jotun/logical/Flag.hx:96: characters 4-10
			--$size;
			#src/jotun/logical/Flag.hx:97: characters 4-43
			$r = ($r??'null') . ((Flag::FTest($hash, 1 << $size) ? "1" : "0")??'null');
			#src/jotun/logical/Flag.hx:98: lines 98-101
			if (++$g === $glen) {
				#src/jotun/logical/Flag.hx:99: characters 5-10
				$g = 0;
				#src/jotun/logical/Flag.hx:100: characters 5-14
				$r = ($r??'null') . ($glue??'null');
			}
		}
		#src/jotun/logical/Flag.hx:103: characters 3-11
		return $r;
	}

	/**
	 * @param mixed $value
	 * 
	 * @return Flag
	 */
	public static function from ($value) {
		#src/jotun/logical/Flag.hx:70: lines 70-72
		if (is_string($value)) {
			#src/jotun/logical/Flag.hx:71: characters 4-31
			$value = \Std::parseInt($value);
		}
		#src/jotun/logical/Flag.hx:73: characters 3-25
		return new Flag($value);
	}

	/**
	 * @param string $hash
	 * 
	 * @return Flag
	 */
	public static function fromCard ($hash) {
		#src/jotun/logical/Flag.hx:55: characters 3-27
		$hash = Utils::trimm($hash);
		#src/jotun/logical/Flag.hx:56: characters 3-27
		$i = mb_strlen($hash);
		#src/jotun/logical/Flag.hx:57: characters 3-17
		$r = 0;
		#src/jotun/logical/Flag.hx:58: characters 3-13
		$f = null;
		#src/jotun/logical/Flag.hx:59: lines 59-65
		while ($i > 0) {
			#src/jotun/logical/Flag.hx:60: characters 4-7
			--$i;
			#src/jotun/logical/Flag.hx:61: characters 4-39
			$f = \Std::parseInt(\mb_substr($hash, $i, 1));
			#src/jotun/logical/Flag.hx:62: lines 62-64
			if ($f > 0) {
				#src/jotun/logical/Flag.hx:63: characters 5-21
				$r |= 1 << $i;
			}
		}
		#src/jotun/logical/Flag.hx:66: characters 3-21
		return new Flag($r);
	}

	/**
	 * @param int $value
	 * 
	 * @return void
	 */
	public function __construct ($value) {
		#src/jotun/logical/Flag.hx:118: characters 3-27
		$this->value = Boot::shiftRightUnsigned($value, 0);
	}

	/**
	 * @param int $bit
	 * 
	 * @return Flag
	 */
	public function drop ($bit) {
		#src/jotun/logical/Flag.hx:132: characters 3-31
		$this->value = Flag::FDrop($this->value, 1 << $bit);
		#src/jotun/logical/Flag.hx:133: characters 3-14
		return $this;
	}

	/**
	 * @param int[]|\Array_hx $bits
	 * 
	 * @return Flag
	 */
	public function dropAll ($bits = null) {
		#src/jotun/logical/Flag.hx:150: lines 150-158
		$_gthis = $this;
		#src/jotun/logical/Flag.hx:151: lines 151-153
		if ($bits === null) {
			#src/jotun/logical/Flag.hx:152: characters 4-16
			$bits = Flag::$_bits;
		}
		#src/jotun/logical/Flag.hx:154: lines 154-156
		Dice::Values($bits, function ($v) use (&$_gthis) {
			#src/jotun/logical/Flag.hx:155: characters 4-14
			$_gthis->drop(1 << $v);
		});
		#src/jotun/logical/Flag.hx:157: characters 3-14
		return $this;
	}

	/**
	 * @return mixed
	 */
	public function getInfo () {
		#src/jotun/logical/Flag.hx:201: characters 9-18
		$tmp = $this->testAll();
		#src/jotun/logical/Flag.hx:202: characters 9-18
		$tmp1 = $this->testAny();
		#src/jotun/logical/Flag.hx:203: characters 10-20
		$tmp2 = $this->testNone();
		#src/jotun/logical/Flag.hx:204: characters 12-20
		$tmp3 = $this->length();
		#src/jotun/logical/Flag.hx:200: lines 200-206
		return new HxAnon([
			"all" => $tmp,
			"any" => $tmp1,
			"none" => $tmp2,
			"length" => $tmp3,
			"value" => $this->toString(),
		]);
	}

	/**
	 * @return int
	 */
	public function length () {
		#src/jotun/logical/Flag.hx:188: characters 3-24
		return Flag::FLength($this->value);
	}

	/**
	 * @param int $bit
	 * 
	 * @return Flag
	 */
	public function put ($bit) {
		#src/jotun/logical/Flag.hx:127: characters 3-30
		$this->value = Flag::FPut($this->value, 1 << $bit);
		#src/jotun/logical/Flag.hx:128: characters 3-14
		return $this;
	}

	/**
	 * @param int[]|\Array_hx $bits
	 * 
	 * @return Flag
	 */
	public function putAll ($bits = null) {
		#src/jotun/logical/Flag.hx:140: lines 140-148
		$_gthis = $this;
		#src/jotun/logical/Flag.hx:141: lines 141-143
		if ($bits === null) {
			#src/jotun/logical/Flag.hx:142: characters 4-16
			$bits = Flag::$_bits;
		}
		#src/jotun/logical/Flag.hx:144: lines 144-146
		Dice::Values($bits, function ($v) use (&$_gthis) {
			#src/jotun/logical/Flag.hx:145: characters 4-13
			$_gthis->put(1 << $v);
		});
		#src/jotun/logical/Flag.hx:147: characters 3-14
		return $this;
	}

	/**
	 * @param int $bit
	 * 
	 * @return bool
	 */
	public function test ($bit) {
		#src/jotun/logical/Flag.hx:137: characters 3-30
		return Flag::FTest($this->value, 1 << $bit);
	}

	/**
	 * @param int[]|\Array_hx $bits
	 * 
	 * @return bool
	 */
	public function testAll ($bits = null) {
		#src/jotun/logical/Flag.hx:169: lines 169-176
		$_gthis = $this;
		#src/jotun/logical/Flag.hx:170: lines 170-172
		if ($bits === null) {
			#src/jotun/logical/Flag.hx:171: characters 4-16
			$bits = Flag::$_bits;
		}
		#src/jotun/logical/Flag.hx:173: lines 173-175
		return Dice::Values($bits, function ($v) use (&$_gthis) {
			#src/jotun/logical/Flag.hx:174: characters 4-19
			return !$_gthis->test($v);
		})->completed;
	}

	/**
	 * @param int[]|\Array_hx $bits
	 * 
	 * @return bool
	 */
	public function testAny ($bits = null) {
		#src/jotun/logical/Flag.hx:178: lines 178-185
		$_gthis = $this;
		#src/jotun/logical/Flag.hx:179: lines 179-181
		if ($bits === null) {
			#src/jotun/logical/Flag.hx:180: characters 4-16
			$bits = Flag::$_bits;
		}
		#src/jotun/logical/Flag.hx:182: lines 182-184
		return !Dice::Values($bits, function ($v) use (&$_gthis) {
			#src/jotun/logical/Flag.hx:183: characters 4-18
			return $_gthis->test($v);
		})->completed;
	}

	/**
	 * @param int[]|\Array_hx $bits
	 * 
	 * @return bool
	 */
	public function testNone ($bits = null) {
		#src/jotun/logical/Flag.hx:160: lines 160-167
		$_gthis = $this;
		#src/jotun/logical/Flag.hx:161: lines 161-163
		if ($bits === null) {
			#src/jotun/logical/Flag.hx:162: characters 4-16
			$bits = Flag::$_bits;
		}
		#src/jotun/logical/Flag.hx:164: lines 164-166
		return Dice::Values($bits, function ($v) use (&$_gthis) {
			#src/jotun/logical/Flag.hx:165: characters 4-18
			return $_gthis->test($v);
		})->completed;
	}

	/**
	 * @param int $size
	 * @param int $glen
	 * 
	 * @return string
	 */
	public function toCard ($size = 32, $glen = 8) {
		#src/jotun/logical/Flag.hx:196: characters 3-41
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
		#src/jotun/logical/Flag.hx:192: characters 3-40
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
		#src/jotun/logical/Flag.hx:122: characters 3-30
		$this->value = Flag::FToggle($this->value, $bit);
		#src/jotun/logical/Flag.hx:123: characters 3-14
		return $this;
	}

	public function __toString() {
		return $this->toString();
	}

	/**
	 * @internal
	 * @access private
	 */
	static public function __hx__init ()
	{
		static $called = false;
		if ($called) return;
		$called = true;


		self::$_bits = \Array_hx::wrap([
			0,
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10,
			11,
			12,
			13,
			14,
			15,
			16,
			17,
			18,
			19,
			20,
			21,
			22,
			23,
			24,
			25,
			26,
			27,
			28,
			29,
			30,
			31,
		]);
	}
}

Boot::registerClass(Flag::class, 'jotun.logical.Flag');
Flag::__hx__init();