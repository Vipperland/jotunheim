<?php

class sirius_errors_Error implements sirius_errors_IError{
	public function __construct($code, $message, $object = null) {
		if(!php_Boot::$skip_constructor) {
		$this->object = $object;
		$this->message = $message;
		$this->code = $code;
	}}
	public $object;
	public $message;
	public $code;
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
	function __toString() { return 'sirius.errors.Error'; }
}
