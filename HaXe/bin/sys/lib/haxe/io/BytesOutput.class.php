<?php

class haxe_io_BytesOutput extends haxe_io_Output {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("haxe.io.BytesOutput::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->b = new haxe_io_BytesBuffer();
		$GLOBALS['%s']->pop();
	}}
	public $b;
	public function writeByte($c) {
		$GLOBALS['%s']->push("haxe.io.BytesOutput::writeByte");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->b->b .= _hx_string_or_null(chr($c));
		$GLOBALS['%s']->pop();
	}
	public function writeBytes($buf, $pos, $len) {
		$GLOBALS['%s']->push("haxe.io.BytesOutput::writeBytes");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			if($pos < 0 || $len < 0 || $pos + $len > $buf->length) {
				throw new HException(haxe_io_Error::$OutsideBounds);
			}
			$this->b->b .= _hx_string_or_null(substr($buf->b, $pos, $len));
		}
		{
			$GLOBALS['%s']->pop();
			return $len;
		}
		$GLOBALS['%s']->pop();
	}
	public function getBytes() {
		$GLOBALS['%s']->push("haxe.io.BytesOutput::getBytes");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->b->getBytes();
			$GLOBALS['%s']->pop();
			return $tmp;
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
	function __toString() { return 'haxe.io.BytesOutput'; }
}
