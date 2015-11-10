<?php

class sirius_modules_Request implements sirius_modules_IRequest{
	public function __construct($success, $data, $error = null) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.modules.Request::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->error = $error;
		$this->data = $data;
		$this->success = $success;
		$GLOBALS['%s']->pop();
	}}
	public $data;
	public $success;
	public $error;
	public function object() {
		$GLOBALS['%s']->push("sirius.modules.Request::object");
		$__hx__spos = $GLOBALS['%s']->length;
		if($this->data !== null && strlen($this->data) > 1) {
			$tmp = haxe_Json::phpJsonDecode($this->data);
			$GLOBALS['%s']->pop();
			return $tmp;
		} else {
			$GLOBALS['%s']->pop();
			return null;
		}
		$GLOBALS['%s']->pop();
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
