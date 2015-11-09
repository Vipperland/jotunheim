<?php

class Test_PHP {
	public function __construct(){}
	static function main() {
		sirius_Sirius::$header->access("*", null, null, null);
		sirius_Sirius::$header->setJSON();
		haxe_Log::trace(_hx_deref(new sirius_db_QueryBuilder())->select((new _hx_array(array("id", "email", "name"))), "users", (new _hx_array(array(_hx_anonymous(array("pass" => "=", "token" => "<")), (new _hx_array(array(_hx_anonymous(array("testA" => "=")), (new _hx_array(array(_hx_anonymous(array("testB" => "=", "testC" => "="))))))))))), _hx_anonymous(array()), _hx_anonymous(array("id" => "ASC")), null), _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 27, "className" => "Test_PHP", "methodName" => "main")));
	}
	function __toString() { return 'Test_PHP'; }
}
