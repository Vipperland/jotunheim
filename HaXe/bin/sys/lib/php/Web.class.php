<?php

class php_Web {
	public function __construct(){}
	static function getURI() {
		$s = $_SERVER['REQUEST_URI'];
		return _hx_array_get(_hx_explode("?", $s), 0);
	}
	static $isModNeko;
	function __toString() { return 'php.Web'; }
}
php_Web::$isModNeko = !php_Lib::isCli();
