<?php

// Generated by Haxe 3.4.7
class jotun_net_Request implements jotun_net_IRequest{
	public function __construct($success, $data, $error = null, $url = null, $headers = null) {
		if(!php_Boot::$skip_constructor) {
		$this->url = $url;
		$this->error = $error;
		$this->data = $data;
		$this->success = $success;
		$this->headers = $headers;
	}}
	public $url;
	public $data;
	public $success;
	public $error;
	public $headers;
	public function object() {
		$tmp = null;
		if($this->data !== null) {
			$tmp = strlen($this->data) > 1;
		} else {
			$tmp = false;
		}
		if($tmp) {
			return haxe_Json::phpJsonDecode($this->data);
		} else {
			return null;
		}
	}
	public function getHeader($name) {
		$tmp = $this->headers;
		return Reflect::field($tmp, strtolower($name));
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	function __toString() { return 'jotun.net.Request'; }
}