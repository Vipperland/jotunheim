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
	static function getClassName($o) {
		if($o !== null) {
			return Type::getClassName(Type::getClass($o));
		} else {
			return "null";
		}
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
