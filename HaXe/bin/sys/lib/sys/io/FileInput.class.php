<?php

class sys_io_FileInput extends haxe_io_Input {
	public function __construct($f) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sys.io.FileInput::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->__f = $f;
		$GLOBALS['%s']->pop();
	}}
	public $__f;
	public function readByte() {
		$GLOBALS['%s']->push("sys.io.FileInput::readByte");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = fread($this->__f, 1);
		if(feof($this->__f)) {
			throw new HException(new haxe_io_Eof());
		}
		if(($r === false)) {
			throw new HException(haxe_io_Error::Custom("An error occurred"));
		}
		{
			$tmp = ord($r);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function readBytes($s, $p, $l) {
		$GLOBALS['%s']->push("sys.io.FileInput::readBytes");
		$__hx__spos = $GLOBALS['%s']->length;
		if(feof($this->__f)) {
			throw new HException(new haxe_io_Eof());
		}
		$r = fread($this->__f, $l);
		if(($r === false)) {
			throw new HException(haxe_io_Error::Custom("An error occurred"));
		}
		$b = haxe_io_Bytes::ofString($r);
		$s->blit($p, $b, 0, strlen($r));
		{
			$tmp = strlen($r);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function close() {
		$GLOBALS['%s']->push("sys.io.FileInput::close");
		$__hx__spos = $GLOBALS['%s']->length;
		parent::close();
		if($this->__f !== null) {
			fclose($this->__f);
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
	function __toString() { return 'sys.io.FileInput'; }
}
