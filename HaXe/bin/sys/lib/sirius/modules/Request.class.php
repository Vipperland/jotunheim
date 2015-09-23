<?php

class sirius_modules_Request implements sirius_modules_IRequest{
	public function __construct($success, $data, $error = null) {
		if(!php_Boot::$skip_constructor) {
		$this->error = $error;
		$this->data = $data;
		$this->success = $success;
	}}
	public $data;
	public $success;
	public $error;
	public function json() {
		if($this->data !== null && strlen($this->data) > 1) {
			return haxe_Json::phpJsonDecode($this->data);
		} else {
			return null;
		}
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
	function __toString() { return 'sirius.modules.Request'; }
}
