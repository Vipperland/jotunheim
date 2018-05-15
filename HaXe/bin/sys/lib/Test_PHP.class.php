<?php

class Test_PHP {
	public function __construct(){}
	static function main() {
		haxe_Log::trace("===================================================== Headers", _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 23, "className" => "Test_PHP", "methodName" => "main")));
		sirius_utils_Dice::All(sirius_Sirius::$domain->data, array(new _hx_lambda(array(), "Test_PHP_0"), 'execute'), null);
		haxe_Log::trace("===================================================== Parameters: GET/POST", _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 27, "className" => "Test_PHP", "methodName" => "main")));
		sirius_utils_Dice::All(sirius_Sirius::$domain->params, array(new _hx_lambda(array(), "Test_PHP_1"), 'execute'), null);
		haxe_Log::trace("===================================================== APPLICATION/JSON Content-Type", _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 31, "className" => "Test_PHP", "methodName" => "main")));
		haxe_Log::trace(sirius_tools_Utils::sruString(sirius_Sirius::$domain->input), _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 32, "className" => "Test_PHP", "methodName" => "main")));
		haxe_Log::trace("===================================================== Files", _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 34, "className" => "Test_PHP", "methodName" => "main")));
		haxe_Log::trace(sirius_php_file_Uploader::save((new _hx_array(array((new _hx_array(array(1280, 720))), (new _hx_array(array(720, 480))), (new _hx_array(array(480, 360)))))))->{"list"}, _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 35, "className" => "Test_PHP", "methodName" => "main")));
		sirius_Sirius::$gate->open(sirius_db_Token::localhost("rimproject", null, null), true);
		if(sirius_Sirius::$gate->isOpen()) {
			haxe_Log::trace("HANDSHAKE OK", _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 39, "className" => "Test_PHP", "methodName" => "main")));
			$t = sirius_Sirius::$gate->table("test");
			$t->add(_hx_anonymous(array("mystring" => sirius_tools_Key::GEN(32, null, null), "mybool" => Math::random() > .5, "myint2" => Std::int(Math::random() * 100))), null, null, null);
			$t->findAll(sirius_db_Clause::hAND((new _hx_array(array(sirius_db_Clause::NOT_NULL("mystring"))))), null, null)->each(array(new _hx_lambda(array(&$t), "Test_PHP_2"), 'execute'));
		} else {
			haxe_Log::trace(sirius_Sirius::$gate->get_errors(), _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 46, "className" => "Test_PHP", "methodName" => "main")));
		}
	}
	function __toString() { return 'Test_PHP'; }
}
function Test_PHP_0($p, $v) {
	{
		haxe_Log::trace(_hx_string_or_null($p) . ": " . _hx_string_or_null($v), _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 25, "className" => "Test_PHP", "methodName" => "main")));
	}
}
function Test_PHP_1($p1, $v1) {
	{
		haxe_Log::trace(_hx_string_or_null($p1) . ": " . _hx_string_or_null($v1), _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 29, "className" => "Test_PHP", "methodName" => "main")));
	}
}
function Test_PHP_2(&$t, $o) {
	{
		haxe_Log::trace($o->data->mystring, _hx_anonymous(array("fileName" => "Test_PHP.hx", "lineNumber" => 43, "className" => "Test_PHP", "methodName" => "main")));
	}
}
