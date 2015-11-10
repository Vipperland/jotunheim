<?php

class sirius_Sirius {
	public function __construct(){}
	static $_initialized = false;
	static $_loaded = false;
	static $resources;
	static $domain;
	static $logger;
	static function main() {
		$GLOBALS['%s']->push("sirius.Sirius::main");
		$__hx__spos = $GLOBALS['%s']->length;
		$GLOBALS['%s']->pop();
	}
	static $header;
	static $gate;
	static $loader;
	static function hrequire($file) {
		$GLOBALS['%s']->push("sirius.Sirius::require");
		$__hx__spos = $GLOBALS['%s']->length;
		require_once($file);
		$GLOBALS['%s']->pop();
	}
	static function module($file, $content = null, $handler = null) {
		$GLOBALS['%s']->push("sirius.Sirius::module");
		$__hx__spos = $GLOBALS['%s']->length;
		sirius_Sirius::$loader->async($file, $content, $handler);
		$GLOBALS['%s']->pop();
	}
	static function request($url, $data = null, $handler = null, $method = null) {
		$GLOBALS['%s']->push("sirius.Sirius::request");
		$__hx__spos = $GLOBALS['%s']->length;
		if($method === null) {
			$method = "post";
		}
		sirius_Sirius::$loader->request($url, $data, $handler, $method);
		$GLOBALS['%s']->pop();
	}
	static function log($q, $type = null) {
		$GLOBALS['%s']->push("sirius.Sirius::log");
		$__hx__spos = $GLOBALS['%s']->length;
		if($type === null) {
			$type = -1;
		}
		sirius_Sirius::$logger->push($q, $type);
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.Sirius'; }
}
sirius_Sirius::$resources = new sirius_modules_ModLib();
sirius_Sirius::$domain = new sirius_net_Domain();
sirius_Sirius::$logger = new sirius_data_Logger();
sirius_Sirius::$header = new sirius_php_utils_Header();
sirius_Sirius::$gate = new sirius_db_Gate();
sirius_Sirius::$loader = new sirius_modules_Loader(null);
