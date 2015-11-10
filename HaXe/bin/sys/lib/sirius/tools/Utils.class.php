<?php

class sirius_tools_Utils {
	public function __construct(){}
	static function clearArray($path, $filter = null) {
		$GLOBALS['%s']->push("sirius.tools.Utils::clearArray");
		$__hx__spos = $GLOBALS['%s']->length;
		$copy = (new _hx_array(array()));
		sirius_utils_Dice::Values($path, array(new _hx_lambda(array(&$copy, &$filter, &$path), "sirius_tools_Utils_0"), 'execute'), null);
		{
			$GLOBALS['%s']->pop();
			return $copy;
		}
		$GLOBALS['%s']->pop();
	}
	static function toString($o, $json = null) {
		$GLOBALS['%s']->push("sirius.tools.Utils::toString");
		$__hx__spos = $GLOBALS['%s']->length;
		if($json === true) {
			$tmp = haxe_Json::phpJsonEncode($o, null, null);
			$GLOBALS['%s']->pop();
			return $tmp;
		} else {
			$tmp = Std::string($o);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function sruString($o) {
		$GLOBALS['%s']->push("sirius.tools.Utils::sruString");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = sirius_tools_Utils::_sruFy($o, "", "");
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function _sruFy($o, $i, $b) {
		$GLOBALS['%s']->push("sirius.tools.Utils::_sruFy");
		$__hx__spos = $GLOBALS['%s']->length;
		$i = _hx_string_or_null($i) . "  ";
		sirius_utils_Dice::All($o, array(new _hx_lambda(array(&$b, &$i, &$o), "sirius_tools_Utils_1"), 'execute'), null);
		{
			$GLOBALS['%s']->pop();
			return $b;
		}
		$GLOBALS['%s']->pop();
	}
	static function isValid($o) {
		$GLOBALS['%s']->push("sirius.tools.Utils::isValid");
		$__hx__spos = $GLOBALS['%s']->length;
		if($o !== null) {
			if(Std::is($o, _hx_qtype("String"))) {
				$tmp = _hx_len($o) > 0;
				$GLOBALS['%s']->pop();
				return $tmp;
			} else {
				$GLOBALS['%s']->pop();
				return true;
			}
		}
		{
			$GLOBALS['%s']->pop();
			return false;
		}
		$GLOBALS['%s']->pop();
	}
	static function typeof($o) {
		$GLOBALS['%s']->push("sirius.tools.Utils::typeof");
		$__hx__spos = $GLOBALS['%s']->length;
		$name = null;
		if($o !== null) {
			try {
				{
					$tmp = $o->__proto__->{"__class__"}->__name__->join(".");
					$GLOBALS['%s']->pop();
					return $tmp;
				}
			}catch(Exception $__hx__e) {
				$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
				$e = $_ex_;
				{
					$GLOBALS['%e'] = (new _hx_array(array()));
					while($GLOBALS['%s']->length >= $__hx__spos) {
						$GLOBALS['%e']->unshift($GLOBALS['%s']->pop());
					}
					$GLOBALS['%s']->push($GLOBALS['%e'][0]);
				}
			}
			try {
				{
					$tmp = Type::getClassName(Type::getClass($o));
					$GLOBALS['%s']->pop();
					return $tmp;
				}
			}catch(Exception $__hx__e) {
				$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
				$e1 = $_ex_;
				{
					$GLOBALS['%e'] = (new _hx_array(array()));
					while($GLOBALS['%s']->length >= $__hx__spos) {
						$GLOBALS['%e']->unshift($GLOBALS['%s']->pop());
					}
					$GLOBALS['%s']->push($GLOBALS['%e'][0]);
				}
			}
		}
		{
			$GLOBALS['%s']->pop();
			return null;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.tools.Utils'; }
}
function sirius_tools_Utils_0(&$copy, &$filter, &$path, $v) {
	{
		$GLOBALS['%s']->push("sirius.tools.Utils::clearArray@178");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if($v !== null && !_hx_equal($v, "") && ($filter === null || call_user_func_array($filter, array($v)))) {
			$copy[$copy->length] = $v;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_tools_Utils_1(&$b, &$i, &$o, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.tools.Utils::_sruFy@209");
		$__hx__spos2 = $GLOBALS['%s']->length;
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
		$GLOBALS['%s']->pop();
	}
}
