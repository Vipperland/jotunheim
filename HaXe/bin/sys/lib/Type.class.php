<?php

class Type {
	public function __construct(){}
	static function getClass($o) {
		if($o === null) {
			return null;
		}
		if(is_array($o)) {
			if(count($o) === 2 && is_callable($o)) {
				return null;
			}
			return _hx_ttype("Array");
		}
		if(is_string($o)) {
			if(_hx_is_lambda($o)) {
				return null;
			}
			return _hx_ttype("String");
		}
		if(!is_object($o)) {
			return null;
		}
		$c = get_class($o);
		if($c === false || $c === "_hx_anonymous" || is_subclass_of($c, "enum")) {
			return null;
		} else {
			return _hx_ttype($c);
		}
	}
	static function getClassName($c) {
		if($c === null) {
			return null;
		}
		return $c->__qname__;
	}
	static function typeof($v) {
		if($v === null) {
			return ValueType::$TNull;
		}
		if(is_array($v)) {
			if(is_callable($v)) {
				return ValueType::$TFunction;
			}
			return ValueType::TClass(_hx_qtype("Array"));
		}
		if(is_string($v)) {
			if(_hx_is_lambda($v)) {
				return ValueType::$TFunction;
			}
			return ValueType::TClass(_hx_qtype("String"));
		}
		if(is_bool($v)) {
			return ValueType::$TBool;
		}
		if(is_int($v)) {
			return ValueType::$TInt;
		}
		if(is_float($v)) {
			return ValueType::$TFloat;
		}
		if($v instanceof _hx_anonymous) {
			return ValueType::$TObject;
		}
		if($v instanceof _hx_enum) {
			return ValueType::$TObject;
		}
		if($v instanceof _hx_class) {
			return ValueType::$TObject;
		}
		$c = _hx_ttype(get_class($v));
		if($c instanceof _hx_enum) {
			return ValueType::TEnum($c);
		}
		if($c instanceof _hx_class) {
			return ValueType::TClass($c);
		}
		return ValueType::$TUnknown;
	}
	function __toString() { return 'Type'; }
}
