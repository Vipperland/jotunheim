<?php

class sirius_tools_BitIO {
	public function __construct($value) {
		if(!php_Boot::$skip_constructor) {
		if(!Std::is($value, _hx_qtype("Float")) && Std::is($value, _hx_qtype("Int"))) {
			$value = Std::parseInt($value);
		}
		$this->value = $value;
	}}
	public $value;
	public function invert($bit) {
		$this->value = sirius_tools_BitIO::Toggle($this->value, $bit);
	}
	public function set($bit) {
		$this->value = sirius_tools_BitIO::Write($this->value, $bit);
	}
	public function hunset($bit) {
		$this->value = sirius_tools_BitIO::Unwrite($this->value, $bit);
	}
	public function get($bit) {
		return sirius_tools_BitIO::Test($this->value, $bit);
	}
	public function valueOf($size = null) {
		if($size === null) {
			$size = 32;
		}
		return sirius_tools_BitIO::Value($this->value, $size);
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	static $P01 = 1;
	static $P02 = 2;
	static $P03 = 4;
	static $P04 = 8;
	static $P05 = 16;
	static $P06 = 32;
	static $P07 = 64;
	static $P08 = 128;
	static $P09 = 256;
	static $P10 = 512;
	static $P11 = 1024;
	static $P12 = 2048;
	static $P13 = 4096;
	static $P14 = 8192;
	static $P15 = 16384;
	static $P16 = 32768;
	static $P17 = 65536;
	static $P18 = 131072;
	static $P19 = 262144;
	static $P20 = 524288;
	static $P21 = 1048576;
	static $P22 = 2097152;
	static $P23 = 4194304;
	static $P24 = 8388608;
	static $P25 = 16777216;
	static $P26 = 33554432;
	static $P27 = 67108864;
	static $P28 = 134217728;
	static $P29 = 268435456;
	static $P30 = 536870912;
	static $P31 = 1073741824;
	static $P32 = -2147483648;
	static function Write($hash, $bit) {
		return $hash | $bit;
	}
	static function Unwrite($hash, $bit) {
		return $hash & ~$bit;
	}
	static function Toggle($hash, $bit) {
		if(sirius_tools_BitIO::Test($hash, $bit)) {
			return sirius_tools_BitIO::Unwrite($hash, $bit);
		} else {
			return sirius_tools_BitIO::Write($hash, $bit);
		}
	}
	static function Test($hash, $value) {
		return _hx_equal(($hash & $value), $value);
	}
	static function Value($hash, $size = null) {
		if($size === null) {
			$size = 32;
		}
		$v = _hx_string_call($hash, "toString", array(2));
		while(sirius_tools_BitIO_0($hash, $size, $v)) {
			$v = "0" . _hx_string_or_null($v);
		}
		return $v;
	}
	static $X;
	function __toString() { return 'sirius.tools.BitIO'; }
}
sirius_tools_BitIO::$X = (new _hx_array(array((isset(sirius_tools_BitIO::$Unwrite) ? sirius_tools_BitIO::$Unwrite: array("sirius_tools_BitIO", "Unwrite")), (isset(sirius_tools_BitIO::$Write) ? sirius_tools_BitIO::$Write: array("sirius_tools_BitIO", "Write")), (isset(sirius_tools_BitIO::$Toggle) ? sirius_tools_BitIO::$Toggle: array("sirius_tools_BitIO", "Toggle")))));
function sirius_tools_BitIO_0(&$hash, &$size, &$v) {
	{
		$a = strlen($v);
		{
			$aNeg = $size < 0;
			$bNeg = $a < 0;
			if($aNeg !== $bNeg) {
				return $aNeg;
			} else {
				return $size > $a;
			}
			unset($bNeg,$aNeg);
		}
		unset($a);
	}
}
