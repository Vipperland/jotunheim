<?php

class sirius_tools_Flag {
	public function __construct($value) {
		if(!php_Boot::$skip_constructor) {
		if(!Std::is($value, _hx_qtype("Float")) && Std::is($value, _hx_qtype("Int"))) {
			$value = Std::parseInt($value);
		}
		$this->value = _hx_shift_right($value, 0);
	}}
	public $value;
	public function toggle($bit) {
		$this->value = sirius_tools_Flag::FToggle($this->value, $bit);
		return $this;
	}
	public function put($bit) {
		$this->value = sirius_tools_Flag::FPut($this->value, 1 << $bit);
		return $this;
	}
	public function drop($bit) {
		$this->value = sirius_tools_Flag::FDrop($this->value, 1 << $bit);
		return $this;
	}
	public function test($bit) {
		return sirius_tools_Flag::FTest($this->value, 1 << $bit);
	}
	public function putAll($bits) {
		$_g = $this;
		sirius_utils_Dice::Values($bits, array(new _hx_lambda(array(&$_g, &$bits), "sirius_tools_Flag_0"), 'execute'), null);
		return $this;
	}
	public function dropAll($bits) {
		$_g = $this;
		sirius_utils_Dice::Values($bits, array(new _hx_lambda(array(&$_g, &$bits), "sirius_tools_Flag_1"), 'execute'), null);
		return $this;
	}
	public function testAll($bits) {
		$_g = $this;
		return sirius_utils_Dice::Values($bits, array(new _hx_lambda(array(&$_g, &$bits), "sirius_tools_Flag_2"), 'execute'), null)->completed;
	}
	public function testAny($bits, $min = null) {
		if($min === null) {
			$min = 1;
		}
		$_g = $this;
		return !sirius_utils_Dice::Values($bits, array(new _hx_lambda(array(&$_g, &$bits, &$min), "sirius_tools_Flag_3"), 'execute'), null)->completed;
	}
	public function length() {
		return sirius_tools_Flag::FLength($this->value);
	}
	public function toString($skip = null) {
		if($skip === null) {
			$skip = 0;
		}
		return sirius_tools_Flag::FValue($this->value, $skip);
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
	static function from($hash) {
		if(Std::is($hash, _hx_qtype("String"))) {
			$hash = Std::parseInt($hash);
		}
		return new sirius_tools_Flag($hash);
	}
	static function FPut($hash, $bit) {
		return $hash | $bit;
	}
	static function FDrop($hash, $bit) {
		return $hash & ~$bit;
	}
	static function FToggle($hash, $bit) {
		if(sirius_tools_Flag::FTest($hash, $bit)) {
			return sirius_tools_Flag::FDrop($hash, $bit);
		} else {
			return sirius_tools_Flag::FPut($hash, $bit);
		}
	}
	static function FTest($hash, $value) {
		return _hx_equal(($hash & $value), $value);
	}
	static function FValue($hash, $skip = null) {
		if($skip === null) {
			$skip = 0;
		}
		$v = _hx_string_call($hash, "toString", array(2));
		$i = strlen($v);
		while(sirius_tools_Flag_4($hash, $i, $skip, $v)) {
			$v = "0" . _hx_string_or_null($v);
			++$i;
		}
		$i = Std::int(_hx_mod(sirius_tools_Flag_5($hash, $i, $skip, $v), sirius_tools_Flag_6($hash, $i, $skip, $v)));
		$r = "";
		while(sirius_tools_Flag_7($hash, $i, $r, $skip, $v)) {
			$r .= _hx_string_or_null(_hx_substr($v, $i * 4, 4)) . _hx_string_or_null((((sirius_tools_Flag_8($hash, $i, $r, $skip, $v)) ? " " : "")));
		}
		return $r;
	}
	static function FLength($hash) {
		$count = 0;
		while(sirius_tools_Flag_9($count, $hash)) {
			$hash = $hash & $hash - 1;
			++$count;
		}
		return $count;
	}
	function __toString() { return $this->toString(); }
}
function sirius_tools_Flag_0(&$_g, &$bits, $v) {
	{
		$_g->put(1 << $v);
	}
}
function sirius_tools_Flag_1(&$_g, &$bits, $v) {
	{
		$_g->drop(1 << $v);
	}
}
function sirius_tools_Flag_2(&$_g, &$bits, $v) {
	{
		return !$_g->test($v);
	}
}
function sirius_tools_Flag_3(&$_g, &$bits, &$min, $v) {
	{
		if($_g->test($v)) {
			--$min;
		}
		return $min === 0;
	}
}
function sirius_tools_Flag_4(&$hash, &$i, &$skip, &$v) {
	{
		$aNeg = 32 < 0;
		$bNeg = $i < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return 32 > $i;
		}
		unset($bNeg,$aNeg);
	}
}
function sirius_tools_Flag_5(&$hash, &$i, &$skip, &$v) {
	{
		$int = $skip;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_tools_Flag_6(&$hash, &$i, &$skip, &$v) {
	{
		$int1 = 8;
		if($int1 < 0) {
			return 4294967296.0 + $int1;
		} else {
			return $int1 + 0.0;
		}
		unset($int1);
	}
}
function sirius_tools_Flag_7(&$hash, &$i, &$r, &$skip, &$v) {
	{
		$aNeg1 = 8 < 0;
		$bNeg1 = $i < 0;
		if($aNeg1 !== $bNeg1) {
			return $aNeg1;
		} else {
			return 8 > $i;
		}
		unset($bNeg1,$aNeg1);
	}
}
function sirius_tools_Flag_8(&$hash, &$i, &$r, &$skip, &$v) {
	{
		$a = ++$i;
		{
			$aNeg2 = 8 < 0;
			$bNeg2 = $a < 0;
			if($aNeg2 !== $bNeg2) {
				return $aNeg2;
			} else {
				return 8 > $a;
			}
			unset($bNeg2,$aNeg2);
		}
		unset($a);
	}
}
function sirius_tools_Flag_9(&$count, &$hash) {
	{
		$aNeg = $hash < 0;
		$bNeg = 0 < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return $hash > 0;
		}
		unset($bNeg,$aNeg);
	}
}
