<?php

class php_Lib {
	public function __construct(){}
	static function hprint($v) {
		$GLOBALS['%s']->push("php.Lib::print");
		$__hx__spos = $GLOBALS['%s']->length;
		echo(Std::string($v));
		$GLOBALS['%s']->pop();
	}
	static function dump($v) {
		$GLOBALS['%s']->push("php.Lib::dump");
		$__hx__spos = $GLOBALS['%s']->length;
		var_dump($v);
		$GLOBALS['%s']->pop();
	}
	static function toPhpArray($a) {
		$GLOBALS['%s']->push("php.Lib::toPhpArray");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $a->a;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function associativeArrayOfHash($hash) {
		$GLOBALS['%s']->push("php.Lib::associativeArrayOfHash");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $hash->h;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function objectOfAssociativeArray($arr) {
		$GLOBALS['%s']->push("php.Lib::objectOfAssociativeArray");
		$__hx__spos = $GLOBALS['%s']->length;
		foreach($arr as $key => $value){
			if(is_array($value)) $arr[$key] = php_Lib::objectOfAssociativeArray($value);
		}
		{
			$tmp = _hx_anonymous($arr);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function associativeArrayOfObject($ob) {
		$GLOBALS['%s']->push("php.Lib::associativeArrayOfObject");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = (array) $ob;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'php.Lib'; }
}
