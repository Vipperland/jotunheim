<?php

class sirius_net_Header {
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
		if(!sirius_net_Header::$hasType) {
			sirius_net_Header::$hasType = true;
			header("content-type:" . ": " . _hx_string_or_null($type));
		}
	}
	public function setHTML() {
		$this->content(sirius_net_Header::$HTML);
	}
	public function setJSON($data = null, $encode = null) {
		$this->content(sirius_net_Header::$JSON);
		if($data !== null) {
			$data1 = sirius_serial_JsonTool::stringfy($data, null, " ");
			if($encode === true) {
				$data1 = sirius_serial_IOTools::encodeBase64($data1);
			}
			php_Lib::hprint($data1);
		}
	}
	public function setTEXT() {
		$this->content(sirius_net_Header::$TEXT);
	}
	public function setURI($value) {
		header("location" . ": " . _hx_string_or_null($value));
	}
	public function setOAuth($token) {
		$v = sirius_serial_IOTools::encodeBase64($token);
		header("Authorization:" . ": " . _hx_string_or_null($v));
	}
	static $HTML = "text/html;charset=utf-8";
	static $TEXT = "text/plain;charset=utf-8";
	static $JSON = "application/json;charset=utf-8";
	static $JSONP = "application/javascript;charset=utf-8";
	static $hasType = false;
	function __toString() { return 'sirius.net.Header'; }
}
