<?php

class sirius_php_utils_Header {
	public function __construct() {}
	public function access($origin = null, $methods = null, $headers = null, $credentials = null) { if(!php_Boot::$skip_constructor) {
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
	}}
	public function content($type) {
		header("content-type:" . ": " . _hx_string_or_null($type));
	}
	public function setJSON($data = null) {
		$this->content(sirius_php_utils_Header::$JSON);
		if($data !== null) {
			php_Lib::hprint(haxe_Json::phpJsonEncode($data, null, null));
		}
	}
	public function setTEXT() {
		$this->content(sirius_php_utils_Header::$TEXT);
	}
	static $HTML = "text/html;charset=utf-8";
	static $TEXT = "text/plain;charset=utf-8";
	static $JSON = "application/json;charset=utf-8";
	static $JSONP = "application/javascript;charset=utf-8";
	function __toString() { return 'sirius.php.utils.Header'; }
}
