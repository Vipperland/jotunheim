<?php

class sirius_tools_Utils {
	public function __construct(){}
	static function getMin($values, $filter = null) {
		$r = null;
		sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$filter, &$r, &$values), "sirius_tools_Utils_0"), 'execute'), null);
		return $r;
	}
	static function getMax($values, $filter = null) {
		$r = null;
		sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$filter, &$r, &$values), "sirius_tools_Utils_1"), 'execute'), null);
		return $r;
	}
	static function getQueryParams($value) {
		$params = _hx_anonymous(array());
		if(_hx_index_of($value, "?", null) > 0) {
			$value = _hx_array_get(_hx_explode("?", _hx_explode("+", $value)->join(" ")), 1);
		} else {
			return $params;
		}
		sirius_utils_Dice::Values(_hx_explode("&", $value), array(new _hx_lambda(array(&$params, &$value), "sirius_tools_Utils_2"), 'execute'), null);
		return $params;
	}
	static function clearArray($path, $filter = null) {
		$copy = (new _hx_array(array()));
		sirius_utils_Dice::Values($path, array(new _hx_lambda(array(&$copy, &$filter, &$path), "sirius_tools_Utils_3"), 'execute'), null);
		return $copy;
	}
	static function toString($o, $json = null) {
		if($json === true) {
			return haxe_Json::phpJsonEncode($o, null, null);
		} else {
			return Std::string($o);
		}
	}
	static function sruString($o) {
		return sirius_tools_Utils::_sruFy($o, "", "");
	}
	static function _sruFy($o, $i, $b) {
		$i = _hx_string_or_null($i) . "  ";
		sirius_utils_Dice::All($o, array(new _hx_lambda(array(&$b, &$i, &$o), "sirius_tools_Utils_4"), 'execute'), null);
		return $b;
	}
	static function isValid($o) {
		if($o !== null && !_hx_equal($o, "")) {
			if(!_hx_equal($o, "null") && _hx_has_field($o, "length")) {
				return _hx_len($o) > 0;
			} else {
				return !_hx_equal($o, 0) && !_hx_equal($o, false);
			}
		}
		return false;
	}
	static function isValidAlt($o, $alt) {
		if(sirius_tools_Utils::isValid($o)) {
			return $o;
		} else {
			return $alt;
		}
	}
	static function typeof($o) {
		$name = null;
		if($o !== null) {
			try {
				return $o->__proto__->{"__class__"}->__name__->join(".");
			}catch(Exception $__hx__e) {
				$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
				$e = $_ex_;
				{}
			}
			try {
				return Type::getClassName(Type::getClass($o));
			}catch(Exception $__hx__e) {
				$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
				$e1 = $_ex_;
				{}
			}
		}
		return null;
	}
	static function boolean($q) {
		return _hx_equal($q, true) || _hx_equal($q, 1) || _hx_equal($q, "1") || _hx_equal($q, "true") || _hx_equal($q, "yes") || _hx_equal($q, "accept");
	}
	static function money($val, $s = null, $a = null, $b = null) {
		if($b === null) {
			$b = ".";
		}
		if($a === null) {
			$a = ",";
		}
		if($s === null) {
			$s = "\$";
		}
		$r = "";
		$val *= 100;
		if($val > 99) {
			$val = "" . _hx_string_rec(Std::int($val), "");
			$i = _hx_len($val);
			$c = 0;
			while($i-- > 0) {
				$r = Std::string(_hx_string_call($val, "substr", array($i, 1))) . _hx_string_or_null($r);
				if($i > 0) {
					if($c === 1) {
						$r = _hx_string_or_null($b) . _hx_string_or_null($r);
					} else {
						if($c > 1 && _hx_mod(($c + 2), 3) === 0) {
							$r = _hx_string_or_null($a) . _hx_string_or_null($r);
						}
					}
				} else {
					if($c < 3) {
						$r = "0" . _hx_string_or_null(((($c === 1) ? "." : ""))) . _hx_string_or_null($r);
					}
				}
				++$c;
			}
		} else {
			$r = "0" . _hx_string_or_null($b) . _hx_string_or_null(((($val < 10) ? "0" : ""))) . Std::string($val);
		}
		return _hx_string_or_null($s) . _hx_string_or_null($r);
	}
	static function stdClone($q) {
		$text = haxe_Json::phpJsonEncode($q, null, null);
		return haxe_Json::phpJsonDecode($text);
	}
	static function paramsOf($o) {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::All($o, array(new _hx_lambda(array(&$o, &$r), "sirius_tools_Utils_5"), 'execute'), null);
		return $r->join("&");
	}
	function __toString() { return 'sirius.tools.Utils'; }
}
function sirius_tools_Utils_0(&$filter, &$r, &$values, $i) {
	{
		if($filter === null || call_user_func_array($filter, array($i))) {
			if($i < $r || $r === null) {
				$r = $i;
			}
		}
	}
}
function sirius_tools_Utils_1(&$filter, &$r, &$values, $i) {
	{
		if($filter === null || call_user_func_array($filter, array($i))) {
			if($i > $r || $r === null) {
				$r = $i;
			}
		}
	}
}
function sirius_tools_Utils_2(&$params, &$value, $v) {
	{
		$data = _hx_explode("=", $v);
		if($data->length > 1) {
			$field = null;
			{
				$s = $data[0];
				$field = urldecode($s);
			}
			$value1 = null;
			{
				$s1 = $data[1];
				$value1 = urldecode($s1);
			}
			$params->{$field} = $value1;
		}
	}
}
function sirius_tools_Utils_3(&$copy, &$filter, &$path, $v) {
	{
		if($v !== null && !_hx_equal($v, "") && ($filter === null || call_user_func_array($filter, array($v)))) {
			$copy[$copy->length] = $v;
		}
	}
}
function sirius_tools_Utils_4(&$b, &$i, &$o, $p, $v) {
	{
		if($v === null) {
			$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . ":* = NULL\x0D";
		} else {
			if(Std::is($v, _hx_qtype("String"))) {
				$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . ":String = " . Std::string($v) . "\x0D";
			} else {
				if(Std::is($v, _hx_qtype("Bool"))) {
					$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . ":Bool = " . Std::string($v) . "\x0D";
				} else {
					if(Std::is($v, _hx_qtype("Int")) || Std::is($v, _hx_qtype("Float"))) {
						$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . ":Number = " . Std::string($v) . "\x0D";
					} else {
						if(Std::is($v, _hx_qtype("Array"))) {
							$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . ":Array[" . Std::string(_hx_len($v)) . "]:[\x0D" . _hx_string_or_null(sirius_tools_Utils::_sruFy($v, $i, "")) . _hx_string_or_null($i) . "]\x0D";
						} else {
							$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . ":Object {\x0D" . _hx_string_or_null(sirius_tools_Utils::_sruFy($v, $i, "")) . _hx_string_or_null($i) . "}\x0D";
						}
					}
				}
			}
		}
	}
}
function sirius_tools_Utils_5(&$o, &$r, $p, $v) {
	{
		$v = haxe_Json::phpJsonEncode($v, null, null);
		$r[$r->length] = _hx_string_or_null($p) . "=" . _hx_string_or_null(sirius_tools_Utils_6($o, $p, $r, $v));
	}
}
function sirius_tools_Utils_6(&$o, &$p, &$r, &$v) {
	{
		$s = _hx_string_call($v, "substr", array(1, _hx_len($v) - 2));
		return rawurlencode($s);
	}
}
