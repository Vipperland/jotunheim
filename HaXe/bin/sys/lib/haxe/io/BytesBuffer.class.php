<?php

class haxe_io_BytesBuffer {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("haxe.io.BytesBuffer::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->b = "";
		$GLOBALS['%s']->pop();
	}}
	public $b;
	public function getBytes() {
		$GLOBALS['%s']->push("haxe.io.BytesBuffer::getBytes");
		$__hx__spos = $GLOBALS['%s']->length;
		$bytes = new haxe_io_Bytes(strlen($this->b), $this->b);
		$this->b = null;
		{
			$GLOBALS['%s']->pop();
			return $bytes;
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
	function __toString() { return 'haxe.io.BytesBuffer'; }
}
