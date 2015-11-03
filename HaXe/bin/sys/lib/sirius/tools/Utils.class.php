<?php

class sirius_tools_Utils {
	public function __construct(){}
	static function clearArray($path, $filter = null) {
		$copy = (new _hx_array(array()));
		sirius_utils_Dice::Values($path, array(new _hx_lambda(array(&$copy, &$filter, &$path), "sirius_tools_Utils_0"), 'execute'), null);
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
		sirius_utils_Dice::All($o, array(new _hx_lambda(array(&$b, &$i, &$o), "sirius_tools_Utils_1"), 'execute'), null);
		return $b;
	}
	static function isValid($o) {
		if($o !== null) {
			if(Std::is($o, _hx_qtype("String"))) {
				return _hx_len($o) > 0;
			} else {
				return true;
			}
		}
		return false;
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
	function __toString() { return 'sirius.tools.Utils'; }
}
function sirius_tools_Utils_0(&$copy, &$filter, &$path, $v) {
	{
		if($v !== null && !_hx_equal($v, "") && ($filter === null || call_user_func_array($filter, array($v)))) {
			$copy[$copy->length] = $v;
		}
	}
}
function sirius_tools_Utils_1(&$b, &$i, &$o, $p, $v) {
	{
		if($v === null) {
			$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . " (null) = NULL\x0D";
		} else {
			if(Std::is($v, _hx_qtype("String"))) {
				$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . " (string) = " . Std::string($v) . "\x0D";
			} else {
				if(Std::is($v, _hx_qtype("Bool"))) {
					$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . " (bool) = " . Std::string($v) . "\x0D";
				} else {
					if(Std::is($v, _hx_qtype("Int")) || Std::is($v, _hx_qtype("Float"))) {
						$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . " (number) = " . Std::string($v) . "\x0D";
					} else {
						if(Std::is($v, _hx_qtype("Array"))) {
							$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . " (array):{\x0D" . _hx_string_or_null(sirius_tools_Utils::_sruFy($v, $i, "")) . _hx_string_or_null($i) . "}\x0D";
						} else {
							$b .= _hx_string_or_null($i) . _hx_string_or_null($p) . " (object):{\x0D" . _hx_string_or_null(sirius_tools_Utils::_sruFy($v, $i, "")) . _hx_string_or_null($i) . "}\x0D";
						}
					}
				}
			}
		}
	}
}
