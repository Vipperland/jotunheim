<?php

class sirius_utils_Dice {
	public function __construct(){}
	static function All($q, $each, $complete = null) {
		$v = null;
		$p = null;
		$i = true;
		$k = 0;
		if($q !== null) {
			if(Std::is($q, _hx_qtype("Array"))) {
				$q = php_Lib::objectOfAssociativeArray($q);
			}
			{
				$_g = 0;
				$_g1 = Reflect::fields($q);
				while($_g < $_g1->length) {
					$p1 = $_g1[$_g];
					++$_g;
					$v = Reflect::field($q, $p1);
					if(Reflect::isFunction($v)) {
						continue;
					}
					if(_hx_equal(call_user_func_array($each, array($p1, $v)), true)) {
						$i = false;
						break;
					} else {
						++$k;
						$p1 = null;
						$v = null;
					}
					unset($p1);
				}
			}
		}
		$r = _hx_anonymous(array("param" => $p, "value" => $v, "completed" => $i, "object" => $q, "keys" => $k));
		if($complete !== null) {
			call_user_func_array($complete, array($r));
		}
		return $r;
	}
	static function Params($q, $each, $complete = null) {
		return sirius_utils_Dice::All($q, array(new _hx_lambda(array(&$complete, &$each, &$q), "sirius_utils_Dice_0"), 'execute'), $complete);
	}
	static function Values($q, $each, $complete = null) {
		return sirius_utils_Dice::All($q, array(new _hx_lambda(array(&$complete, &$each, &$q), "sirius_utils_Dice_1"), 'execute'), $complete);
	}
	static function Call($q, $method, $args = null) {
		if($args === null) {
			$args = (new _hx_array(array()));
		}
		return sirius_utils_Dice::All($q, array(new _hx_lambda(array(&$args, &$method, &$q), "sirius_utils_Dice_2"), 'execute'), null);
	}
	static function Count($from, $to, $each, $complete = null, $increment = null) {
		if($increment === null) {
			$increment = 1;
		}
		$a = Math::min($from, $to);
		$b = Math::max($from, $to);
		if($increment === null || sirius_utils_Dice_3($a, $b, $complete, $each, $from, $increment, $to)) {
			$increment = 1;
		}
		while($a < $b) {
			if(_hx_equal(call_user_func_array($each, array($a, $b, ($a = sirius_utils_Dice_4($a, $b, $complete, $each, $from, $increment, $to) + $a) === $b)), true)) {
				break;
			}
		}
		$c = $a === $b;
		$r = _hx_anonymous(array("from" => $from, "to" => $b, "completed" => $c, "value" => $a));
		if($complete !== null) {
			call_user_func_array($complete, array($r));
		}
		return $r;
	}
	static function One($from, $alt = null) {
		if(Std::is($from, _hx_qtype("Array"))) {
			sirius_utils_Dice::Values($from, array(new _hx_lambda(array(&$alt, &$from), "sirius_utils_Dice_5"), 'execute'), null);
		}
		return _hx_anonymous(array("value" => ((sirius_tools_Utils::isValid($from)) ? $from : $alt), "object" => $from));
	}
	static function Match($table, $values) {
		if(!Std::is($values, _hx_qtype("Array"))) {
			$values = (new _hx_array(array($values)));
		}
		$r = 0;
		sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$r, &$table, &$values), "sirius_utils_Dice_6"), 'execute'), null);
		return $r;
	}
	function __toString() { return 'sirius.utils.Dice'; }
}
function sirius_utils_Dice_0(&$complete, &$each, &$q, $p, $v) {
	{
		return call_user_func_array($each, array($p));
	}
}
function sirius_utils_Dice_1(&$complete, &$each, &$q, $p, $v) {
	{
		return call_user_func_array($each, array($v));
	}
}
function sirius_utils_Dice_2(&$args, &$method, &$q, $p, $v) {
	{
		Reflect::callMethod($v, Reflect::field($v, $method), $args);
	}
}
function sirius_utils_Dice_3(&$a, &$b, &$complete, &$each, &$from, &$increment, &$to) {
	{
		$aNeg = 1 < 0;
		$bNeg = $increment < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return 1 > $increment;
		}
		unset($bNeg,$aNeg);
	}
}
function sirius_utils_Dice_4(&$a, &$b, &$complete, &$each, &$from, &$increment, &$to) {
	{
		$int = $increment;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_utils_Dice_5(&$alt, &$from, $v) {
	{
		$from = $v;
		return $from === null;
	}
}
function sirius_utils_Dice_6(&$r, &$table, &$values, $v) {
	{
		if(Lambda::indexOf($table, $v) !== -1) {
			++$r;
		}
	}
}
