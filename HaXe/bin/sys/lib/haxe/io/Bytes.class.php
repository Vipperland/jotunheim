<?php

class haxe_io_Bytes {
	public function __construct($length, $b) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("haxe.io.Bytes::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->length = $length;
		$this->b = $b;
		$GLOBALS['%s']->pop();
	}}
	public $length;
	public $b;
	public function blit($pos, $src, $srcpos, $len) {
		$GLOBALS['%s']->push("haxe.io.Bytes::blit");
		$__hx__spos = $GLOBALS['%s']->length;
		if($pos < 0 || $srcpos < 0 || $len < 0 || $pos + $len > $this->length || $srcpos + $len > $src->length) {
			throw new HException(haxe_io_Error::$OutsideBounds);
		}
		$this->b = substr($this->b, 0, $pos) . substr($src->b, $srcpos, $len) . substr($this->b, $pos+$len);
		$GLOBALS['%s']->pop();
	}
	public function sub($pos, $len) {
		$GLOBALS['%s']->push("haxe.io.Bytes::sub");
		$__hx__spos = $GLOBALS['%s']->length;
		if($pos < 0 || $len < 0 || $pos + $len > $this->length) {
			throw new HException(haxe_io_Error::$OutsideBounds);
		}
		{
			$tmp = new haxe_io_Bytes($len, substr($this->b, $pos, $len));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function getString($pos, $len) {
		$GLOBALS['%s']->push("haxe.io.Bytes::getString");
		$__hx__spos = $GLOBALS['%s']->length;
		if($pos < 0 || $len < 0 || $pos + $len > $this->length) {
			throw new HException(haxe_io_Error::$OutsideBounds);
		}
		{
			$tmp = substr($this->b, $pos, $len);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function toString() {
		$GLOBALS['%s']->push("haxe.io.Bytes::toString");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->b;
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
	static function alloc($length) {
		$GLOBALS['%s']->push("haxe.io.Bytes::alloc");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = new haxe_io_Bytes($length, str_repeat(chr(0), $length));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function ofString($s) {
		$GLOBALS['%s']->push("haxe.io.Bytes::ofString");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = new haxe_io_Bytes(strlen($s), $s);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return $this->toString(); }
}
