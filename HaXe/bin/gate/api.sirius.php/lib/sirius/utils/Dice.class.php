<?php

class sirius_utils_Dice {
	public function __construct(){}
	static function All($q, $each, $complete = null) {
		if($q !== null) {
			$v = null;
			$p = null;
			$c = $complete !== null;
			$i = true;
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
						$p1 = null;
						$v = null;
					}
					unset($p1);
				}
			}
			if($c) {
				call_user_func_array($complete, array($p, $v, $i));
			}
		}
	}
	static function Params($q, $each, $complete = null) {
		sirius_utils_Dice::All($q, array(new _hx_lambda(array(&$complete, &$each, &$q), "sirius_utils_Dice_0"), 'execute'), sirius_utils_Dice_1($complete, $each, $q));
	}
	static function Values($q, $each, $complete = null) {
		sirius_utils_Dice::All($q, array(new _hx_lambda(array(&$complete, &$each, &$q), "sirius_utils_Dice_2"), 'execute'), sirius_utils_Dice_3($complete, $each, $q));
	}
	static function Call($q, $method, $args = null) {
		if($args === null) {
			$args = (new _hx_array(array()));
		}
		sirius_utils_Dice::All($q, array(new _hx_lambda(array(&$args, &$method, &$q), "sirius_utils_Dice_4"), 'execute'), null);
	}
	static function Count($from, $to, $each, $complete = null) {
		$a = Math::min($from, $to);
		$b = Math::max($from, $to);
		while($a < $b) {
			if(_hx_equal(call_user_func_array($each, array($a++, $b)), true)) {
				break;
			}
		}
		if($complete !== null) {
			call_user_func_array($complete, array($a, $a !== $b));
		}
	}
	static function One($from, $alt = null) {
		if(Std::is($from, _hx_qtype("Array"))) {
			sirius_utils_Dice::Values($from, array(new _hx_lambda(array(&$alt, &$from), "sirius_utils_Dice_5"), 'execute'), null);
		}
		if($from === null) {
			return $alt;
		} else {
			return $from;
		}
	}
	function __toString() { return 'sirius.utils.Dice'; }
}
function sirius_utils_Dice_0(&$complete, &$each, &$q, $p, $v) {
	{
		return call_user_func_array($each, array($p));
	}
}
function sirius_utils_Dice_1(&$complete, &$each, &$q) {
	if($complete !== null) {
		return array(new _hx_lambda(array(&$complete, &$each, &$q), "sirius_utils_Dice_6"), 'execute');
	}
}
function sirius_utils_Dice_2(&$complete, &$each, &$q, $p, $v) {
	{
		return call_user_func_array($each, array($v));
	}
}
function sirius_utils_Dice_3(&$complete, &$each, &$q) {
	if($complete !== null) {
		return array(new _hx_lambda(array(&$complete, &$each, &$q), "sirius_utils_Dice_7"), 'execute');
	}
}
function sirius_utils_Dice_4(&$args, &$method, &$q, $p, $v) {
	{
		Reflect::callMethod($v, Reflect::field($v, $method), $args);
	}
}
function sirius_utils_Dice_5(&$alt, &$from, $v) {
	{
		$from = $v;
		return $from === null;
	}
}
function sirius_utils_Dice_6(&$complete, &$each, &$q, $p1, $v1, $i) {
	{
		call_user_func_array($complete, array($p1, $i));
	}
}
function sirius_utils_Dice_7(&$complete, &$each, &$q, $p1, $v1, $i) {
	{
		call_user_func_array($complete, array($v1, $i));
	}
}
