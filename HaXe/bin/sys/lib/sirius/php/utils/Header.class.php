<?php

class sirius_php_utils_Header {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.php.utils.Header::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$GLOBALS['%s']->pop();
	}}
	public function access($origin = null, $methods = null, $headers = null, $credentials = null) {
		$GLOBALS['%s']->push("sirius.php.utils.Header::access");
		$__hx__spos = $GLOBALS['%s']->length;
		if($credentials === null) {
			$credentials = true;
		}
		if($headers === null) {
			$headers = "Origin,Content-Type,Accept,Authorization,X-Request-With";
		}
		if($methods === null) {
			$methods = "GET,POST,OPTIONS";
		}
		if($origin === null) {
			$origin = "*";
		}
		header("Access-Control-Allow-Origin" . ": " . _hx_string_or_null($origin));
		header("Access-Control-Allow-Methods" . ": " . _hx_string_or_null($methods));
		header("Access-Control-Allow-Headers" . ": " . _hx_string_or_null($headers));
		header("Access-Control-Allow-Credentials" . ": " . Std::string($credentials));
		$GLOBALS['%s']->pop();
	}
	public function content($type) {
		$GLOBALS['%s']->push("sirius.php.utils.Header::content");
		$__hx__spos = $GLOBALS['%s']->length;
		header("content-type:" . ": " . _hx_string_or_null($type));
		$GLOBALS['%s']->pop();
	}
	public function setJSON($data = null) {
		$GLOBALS['%s']->push("sirius.php.utils.Header::setJSON");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->content(sirius_php_utils_Header::$JSON);
		if($data !== null) {
			php_Lib::hprint(haxe_Json::phpJsonEncode($data, null, null));
		}
		$GLOBALS['%s']->pop();
	}
	public function setTEXT() {
		$GLOBALS['%s']->push("sirius.php.utils.Header::setTEXT");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->content(sirius_php_utils_Header::$TEXT);
		$GLOBALS['%s']->pop();
	}
	static $HTML = "text/html;charset=utf-8";
	static $TEXT = "text/plain;charset=utf-8";
	static $JSON = "application/json;charset=utf-8";
	static $JSONP = "application/javascript;charset=utf-8";
	function __toString() { return 'sirius.php.utils.Header'; }
}
