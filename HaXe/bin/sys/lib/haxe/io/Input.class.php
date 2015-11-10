<?php

class haxe_io_Input {
	public function __construct(){}
	public function readByte() {
		$GLOBALS['%s']->push("haxe.io.Input::readByte");
		$__hx__spos = $GLOBALS['%s']->length;
		throw new HException("Not implemented");
		$GLOBALS['%s']->pop();
	}
	public function readBytes($s, $pos, $len) {
		$GLOBALS['%s']->push("haxe.io.Input::readBytes");
		$__hx__spos = $GLOBALS['%s']->length;
		$k = $len;
		$b = $s->b;
		if($pos < 0 || $len < 0 || $pos + $len > $s->length) {
			throw new HException(haxe_io_Error::$OutsideBounds);
		}
		while($k > 0) {
			$b[$pos] = chr($this->readByte());
			$pos++;
			$k--;
		}
		{
			$GLOBALS['%s']->pop();
			return $len;
		}
		$GLOBALS['%s']->pop();
	}
	public function close() {
		$GLOBALS['%s']->push("haxe.io.Input::close");
		$__hx__spos = $GLOBALS['%s']->length;
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'haxe.io.Input'; }
}
