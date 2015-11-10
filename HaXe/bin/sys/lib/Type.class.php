<?php

class Type {
	public function __construct(){}
	static function getClass($o) {
		$GLOBALS['%s']->push("Type::getClass");
		$__hx__spos = $GLOBALS['%s']->length;
		if($o === null) {
			$GLOBALS['%s']->pop();
			return null;
		}
		if(is_array($o)) {
			if(count($o) === 2 && is_callable($o)) {
				$GLOBALS['%s']->pop();
				return null;
			}
			{
				$tmp = _hx_ttype("Array");
				$GLOBALS['%s']->pop();
				return $tmp;
			}
		}
		if(is_string($o)) {
			if(_hx_is_lambda($o)) {
				$GLOBALS['%s']->pop();
				return null;
			}
			{
				$tmp = _hx_ttype("String");
				$GLOBALS['%s']->pop();
				return $tmp;
			}
		}
		if(!is_object($o)) {
			$GLOBALS['%s']->pop();
			return null;
		}
		$c = get_class($o);
		if($c === false || $c === "_hx_anonymous" || is_subclass_of($c, "enum")) {
			$GLOBALS['%s']->pop();
			return null;
		} else {
			$tmp = _hx_ttype($c);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function getClassName($c) {
		$GLOBALS['%s']->push("Type::getClassName");
		$__hx__spos = $GLOBALS['%s']->length;
		if($c === null) {
			$GLOBALS['%s']->pop();
			return null;
		}
		{
			$tmp = $c->__qname__;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function typeof($v) {
		$GLOBALS['%s']->push("Type::typeof");
		$__hx__spos = $GLOBALS['%s']->length;
		if($v === null) {
			$tmp = ValueType::$TNull;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		if(is_array($v)) {
			if(is_callable($v)) {
				$tmp = ValueType::$TFunction;
				$GLOBALS['%s']->pop();
				return $tmp;
			}
			{
				$tmp = ValueType::TClass(_hx_qtype("Array"));
				$GLOBALS['%s']->pop();
				return $tmp;
			}
		}
		if(is_string($v)) {
			if(_hx_is_lambda($v)) {
				$tmp = ValueType::$TFunction;
				$GLOBALS['%s']->pop();
				return $tmp;
			}
			{
				$tmp = ValueType::TClass(_hx_qtype("String"));
				$GLOBALS['%s']->pop();
				return $tmp;
			}
		}
		if(is_bool($v)) {
			$tmp = ValueType::$TBool;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		if(is_int($v)) {
			$tmp = ValueType::$TInt;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		if(is_float($v)) {
			$tmp = ValueType::$TFloat;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		if($v instanceof _hx_anonymous) {
			$tmp = ValueType::$TObject;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		if($v instanceof _hx_enum) {
			$tmp = ValueType::$TObject;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		if($v instanceof _hx_class) {
			$tmp = ValueType::$TObject;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$c = _hx_ttype(get_class($v));
		if($c instanceof _hx_enum) {
			$tmp = ValueType::TEnum($c);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		if($c instanceof _hx_class) {
			$tmp = ValueType::TClass($c);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		{
			$tmp = ValueType::$TUnknown;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'Type'; }
}
