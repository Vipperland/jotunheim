<?php

class sirius_utils_Dice {
	public function __construct(){}
	static function All($q, $each, $complete = null) {
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
			if(call_user_func_array($each, array($a, $b, ($a = sirius_utils_Dice_4($a, $b, $complete, $each, $from, $increment, $to) + $a) === $b)) === true) {
				break;
			}
		}
		$c = $a === $b;
		$r = _hx_anonymous(array("from" => $from, "to" => $b, "completed" => $c, "value" => $a - sirius_utils_Dice_5($a, $b, $c, $complete, $each, $from, $increment, $to)));
		if($complete !== null) {
			call_user_func_array($complete, array($r));
		}
		return $r;
	}
	static function One($from, $alt = null) {
		if(Std::is($from, _hx_qtype("Array"))) {
			sirius_utils_Dice::Values($from, array(new _hx_lambda(array(&$alt, &$from), "sirius_utils_Dice_6"), 'execute'), null);
		}
		return _hx_anonymous(array("value" => ((sirius_tools_Utils::isValid($from)) ? $from : $alt), "object" => $from));
	}
	static function Match($table, $values, $limit = null) {
		if($limit === null) {
			$limit = 0;
		}
		if(!Std::is($values, _hx_qtype("Array"))) {
			$values = (new _hx_array(array($values)));
		}
		$r = 0;
		sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$limit, &$r, &$table, &$values), "sirius_utils_Dice_7"), 'execute'), null);
		return $r;
	}
	static function Remove($table, $values) {
		if(!Std::is($values, _hx_qtype("Array"))) {
			$values = (new _hx_array(array($values)));
		}
		sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$table, &$values), "sirius_utils_Dice_8"), 'execute'), null);
	}
	static function Mix($data) {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::Values($data, array(new _hx_lambda(array(&$data, &$r), "sirius_utils_Dice_9"), 'execute'), null);
		return $r;
	}
	static function Table($data, $key = null, $numeric = null, $copy = null) {
		if($copy === null) {
			$copy = false;
		}
		if($numeric === null) {
			$numeric = false;
		}
		$r = null;
		if($copy === true) {
			$r = _hx_deref((new _hx_array(array())))->concat($data);
		} else {
			$r = $data;
		}
		if($numeric) {
			if($key !== null) {
				haxe_ds_ArraySort::sort($r, array(new _hx_lambda(array(&$copy, &$data, &$key, &$numeric, &$r), "sirius_utils_Dice_10"), 'execute'));
			} else {
				haxe_ds_ArraySort::sort($r, array(new _hx_lambda(array(&$copy, &$data, &$key, &$numeric, &$r), "sirius_utils_Dice_11"), 'execute'));
			}
		} else {
			if($key !== null) {
				haxe_ds_ArraySort::sort($r, array(new _hx_lambda(array(&$copy, &$data, &$key, &$numeric, &$r), "sirius_utils_Dice_12"), 'execute'));
			} else {
				haxe_ds_ArraySort::sort($r, array(new _hx_lambda(array(&$copy, &$data, &$key, &$numeric, &$r), "sirius_utils_Dice_13"), 'execute'));
			}
		}
		return $r;
	}
	static function hList($data, $a = null, $b = null) {
		if($a === null) {
			$a = 0;
		}
		$copy = (new _hx_array(array()));
		$len = $data->length;
		if($b === null) {
			$b = $data->length;
		}
		if(sirius_utils_Dice_14($a, $b, $copy, $data, $len)) {
			while(sirius_utils_Dice_15($a, $b, $copy, $data, $len)) {
				if(sirius_utils_Dice_16($a, $b, $copy, $data, $len)) {
					break;
				}
				$copy[$copy->length] = $data[$a];
				++$a;
			}
		} else {
			if(sirius_utils_Dice_17($a, $b, $copy, $data, $len)) {
				while(sirius_utils_Dice_18($a, $b, $copy, $data, $len)) {
					if(sirius_utils_Dice_19($a, $b, $copy, $data, $len)) {
						$copy[$copy->length] = $data[$a];
					}
					--$a;
				}
			}
		}
		return $copy;
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
		$from = $v;
		return $from === null;
	}
}
function sirius_utils_Dice_7(&$limit, &$r, &$table, &$values, $v) {
	{
		if(Lambda::indexOf($table, $v) !== -1) {
			++$r;
		}
		if(sirius_utils_Dice_20($limit, $r, $table, $v, $values)) {
			$a = --$limit;
			return $a === 0;
		}
		return false;
	}
}
function sirius_utils_Dice_8(&$table, &$values, $v) {
	{
		$i = Lambda::indexOf($table, $v);
		if($i !== -1) {
			$table->remove($v);
		}
	}
}
function sirius_utils_Dice_9(&$data, &$r, $v) {
	{
		$r = $r->concat($v);
	}
}
function sirius_utils_Dice_10(&$copy, &$data, &$key, &$numeric, &$r, $a, $b) {
	{
		if(Reflect::field($a, $key) < Reflect::field($b, $key)) {
			return -1;
		} else {
			return 1;
		}
	}
}
function sirius_utils_Dice_11(&$copy, &$data, &$key, &$numeric, &$r, $a1, $b1) {
	{
		if($a1 < $b1) {
			return -1;
		} else {
			return 1;
		}
	}
}
function sirius_utils_Dice_12(&$copy, &$data, &$key, &$numeric, &$r, $a2, $b2) {
	{
		return Reflect::compare(sirius_utils_SearchTag::convert(Reflect::field($a2, $key)), sirius_utils_SearchTag::convert(Reflect::field($b2, $key)));
	}
}
function sirius_utils_Dice_13(&$copy, &$data, &$key, &$numeric, &$r, $a3, $b3) {
	{
		return Reflect::compare(sirius_utils_SearchTag::convert($a3), sirius_utils_SearchTag::convert($b3));
	}
}
function sirius_utils_Dice_14(&$a, &$b, &$copy, &$data, &$len) {
	{
		$aNeg = $b < 0;
		$bNeg = $a < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return $b > $a;
		}
		unset($bNeg,$aNeg);
	}
}
function sirius_utils_Dice_15(&$a, &$b, &$copy, &$data, &$len) {
	{
		$aNeg1 = $b < 0;
		$bNeg1 = $a < 0;
		if($aNeg1 !== $bNeg1) {
			return $aNeg1;
		} else {
			return $b > $a;
		}
		unset($bNeg1,$aNeg1);
	}
}
function sirius_utils_Dice_16(&$a, &$b, &$copy, &$data, &$len) {
	{
		$aNeg2 = $a < 0;
		$bNeg2 = $len < 0;
		if($aNeg2 !== $bNeg2) {
			return $aNeg2;
		} else {
			return $a >= $len;
		}
		unset($bNeg2,$aNeg2);
	}
}
function sirius_utils_Dice_17(&$a, &$b, &$copy, &$data, &$len) {
	{
		$aNeg3 = $a < 0;
		$bNeg3 = $b < 0;
		if($aNeg3 !== $bNeg3) {
			return $aNeg3;
		} else {
			return $a > $b;
		}
		unset($bNeg3,$aNeg3);
	}
}
function sirius_utils_Dice_18(&$a, &$b, &$copy, &$data, &$len) {
	{
		$aNeg4 = $a < 0;
		$bNeg4 = $b < 0;
		if($aNeg4 !== $bNeg4) {
			return $aNeg4;
		} else {
			return $a > $b;
		}
		unset($bNeg4,$aNeg4);
	}
}
function sirius_utils_Dice_19(&$a, &$b, &$copy, &$data, &$len) {
	{
		$aNeg5 = $len < 0;
		$bNeg5 = $a < 0;
		if($aNeg5 !== $bNeg5) {
			return $aNeg5;
		} else {
			return $len > $a;
		}
		unset($bNeg5,$aNeg5);
	}
}
function sirius_utils_Dice_20(&$limit, &$r, &$table, &$v, &$values) {
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
