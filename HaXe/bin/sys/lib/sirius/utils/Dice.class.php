<?php

class sirius_utils_Dice {
	public function __construct(){}
	static function All($q, $each, $complete = null) {
		$GLOBALS['%s']->push("sirius.utils.Dice::All");
		$__hx__spos = $GLOBALS['%s']->length;
		$v = null;
		$p = null;
		$i = true;
		$k = 0;
		if($q !== null) {
			if(Std::is($q, _hx_qtype("php.NativeArray")) || Std::is($q, _hx_qtype("Array"))) {
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
		{
			$GLOBALS['%s']->pop();
			return $r;
		}
		$GLOBALS['%s']->pop();
	}
	static function Params($q, $each, $complete = null) {
		$GLOBALS['%s']->push("sirius.utils.Dice::Params");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = sirius_utils_Dice::All($q, array(new _hx_lambda(array(&$complete, &$each, &$q), "sirius_utils_Dice_0"), 'execute'), $complete);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function Values($q, $each, $complete = null) {
		$GLOBALS['%s']->push("sirius.utils.Dice::Values");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = sirius_utils_Dice::All($q, array(new _hx_lambda(array(&$complete, &$each, &$q), "sirius_utils_Dice_1"), 'execute'), $complete);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function Call($q, $method, $args = null) {
		$GLOBALS['%s']->push("sirius.utils.Dice::Call");
		$__hx__spos = $GLOBALS['%s']->length;
		if($args === null) {
			$args = (new _hx_array(array()));
		}
		{
			$tmp = sirius_utils_Dice::All($q, array(new _hx_lambda(array(&$args, &$method, &$q), "sirius_utils_Dice_2"), 'execute'), null);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function Count($from, $to, $each, $complete = null, $increment = null) {
		$GLOBALS['%s']->push("sirius.utils.Dice::Count");
		$__hx__spos = $GLOBALS['%s']->length;
		if($increment === null) {
			$increment = 1;
		}
		$a = Math::min($from, $to);
		$b = Math::max($from, $to);
		if($increment === null || sirius_utils_Dice_3($a, $b, $complete, $each, $from, $increment, $to)) {
			$increment = 1;
		}
		while($a < $b) {
			if(call_user_func_array($each, array($a, $b, ($a = sirius_utils_Dice_4($a, $b, $complete, $each, $from, $increment, $to) + $a) === $b)) === true) {
				break;
			}
		}
		$c = $a === $b;
		$r = _hx_anonymous(array("from" => $from, "to" => $b, "completed" => $c, "value" => $a - sirius_utils_Dice_5($a, $b, $c, $complete, $each, $from, $increment, $to)));
		if($complete !== null) {
			call_user_func_array($complete, array($r));
		}
		{
			$GLOBALS['%s']->pop();
			return $r;
		}
		$GLOBALS['%s']->pop();
	}
	static function One($from, $alt = null) {
		$GLOBALS['%s']->push("sirius.utils.Dice::One");
		$__hx__spos = $GLOBALS['%s']->length;
		if(Std::is($from, _hx_qtype("Array"))) {
			sirius_utils_Dice::Values($from, array(new _hx_lambda(array(&$alt, &$from), "sirius_utils_Dice_6"), 'execute'), null);
		}
		{
			$tmp = _hx_anonymous(array("value" => ((sirius_tools_Utils::isValid($from)) ? $from : $alt), "object" => $from));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function Match($table, $values, $limit = null) {
		$GLOBALS['%s']->push("sirius.utils.Dice::Match");
		$__hx__spos = $GLOBALS['%s']->length;
		if($limit === null) {
			$limit = 0;
		}
		if(!Std::is($values, _hx_qtype("Array"))) {
			$values = (new _hx_array(array($values)));
		}
		$r = 0;
		sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$limit, &$r, &$table, &$values), "sirius_utils_Dice_7"), 'execute'), null);
		{
			$GLOBALS['%s']->pop();
			return $r;
		}
		$GLOBALS['%s']->pop();
	}
	static function Mix($data) {
		$GLOBALS['%s']->push("sirius.utils.Dice::Mix");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = (new _hx_array(array()));
		sirius_utils_Dice::Values($data, array(new _hx_lambda(array(&$data, &$r), "sirius_utils_Dice_8"), 'execute'), null);
		{
			$GLOBALS['%s']->pop();
			return $r;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.utils.Dice'; }
}
function sirius_utils_Dice_0(&$complete, &$each, &$q, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.utils.Dice::Params@70");
		$__hx__spos2 = $GLOBALS['%s']->length;
		{
			$tmp = call_user_func_array($each, array($p));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_utils_Dice_1(&$complete, &$each, &$q, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.utils.Dice::Values@83");
		$__hx__spos2 = $GLOBALS['%s']->length;
		{
			$tmp = call_user_func_array($each, array($v));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_utils_Dice_2(&$args, &$method, &$q, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.utils.Dice::Call@97");
		$__hx__spos2 = $GLOBALS['%s']->length;
		Reflect::callMethod($v, Reflect::field($v, $method), $args);
		$GLOBALS['%s']->pop();
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
function sirius_utils_Dice_5(&$a, &$b, &$c, &$complete, &$each, &$from, &$increment, &$to) {
	{
		$int1 = $increment;
		if($int1 < 0) {
			return 4294967296.0 + $int1;
		} else {
			return $int1 + 0.0;
		}
		unset($int1);
	}
}
function sirius_utils_Dice_6(&$alt, &$from, $v) {
	{
		$GLOBALS['%s']->push("sirius.utils.Dice::One@132");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$from = $v;
		{
			$tmp = $from === null;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_utils_Dice_7(&$limit, &$r, &$table, &$values, $v) {
	{
		$GLOBALS['%s']->push("sirius.utils.Dice::Match@149");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if(Lambda::indexOf($table, $v) !== -1) {
			++$r;
		}
		if(sirius_utils_Dice_9($limit, $r, $table, $v, $values)) {
			$a = --$limit;
			{
				$tmp = $a === 0;
				$GLOBALS['%s']->pop();
				return $tmp;
			}
		}
		{
			$GLOBALS['%s']->pop();
			return false;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_utils_Dice_8(&$data, &$r, $v) {
	{
		$GLOBALS['%s']->push("sirius.utils.Dice::Mix@164");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$r = $r->concat($v);
		$GLOBALS['%s']->pop();
	}
}
function sirius_utils_Dice_9(&$limit, &$r, &$table, &$v, &$values) {
	{
		$aNeg = $limit < 0;
		$bNeg = 0 < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return $limit > 0;
		}
		unset($bNeg,$aNeg);
	}
}
