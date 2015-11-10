<?php

class sirius_data_Logger {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.data.Logger::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_events = (new _hx_array(array((isset($this->query) ? $this->query: array($this, "query")))));
		$GLOBALS['%s']->pop();
	}}
	public $_bgs;
	public $_events;
	public function silent() {
		$GLOBALS['%s']->push("sirius.data.Logger::silent");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->query("Log => Disconnected", 2);
		if(Lambda::indexOf($this->_events, (isset($this->query) ? $this->query: array($this, "query"))) !== -1) {
			$this->_events->splice(0, 1);
		}
		$GLOBALS['%s']->pop();
	}
	public function listen($handler) {
		$GLOBALS['%s']->push("sirius.data.Logger::listen");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_events[$this->_events->length] = $handler;
		$GLOBALS['%s']->pop();
	}
	public function push($q, $type) {
		$GLOBALS['%s']->push("sirius.data.Logger::push");
		$__hx__spos = $GLOBALS['%s']->length;
		sirius_utils_Dice::Values($this->_events, array(new _hx_lambda(array(&$q, &$type), "sirius_data_Logger_0"), 'execute'), null);
		$GLOBALS['%s']->pop();
	}
	public function query($q, $type) {
		$GLOBALS['%s']->push("sirius.data.Logger::query");
		$__hx__spos = $GLOBALS['%s']->length;
		$t = null;
		switch($type) {
		case 0:{
			$t = "[MESSAGE] ";
		}break;
		case 1:{
			$t = "[>SYSTEM] ";
		}break;
		case 2:{
			$t = "[WARNING] ";
		}break;
		case 3:{
			$t = "[!ERROR!] ";
		}break;
		case 4:{
			$t = "[//TODO:] ";
		}break;
		default:{
			$t = "";
		}break;
		}
		php_Lib::dump($q);
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
	function __toString() { return 'sirius.data.Logger'; }
}
function sirius_data_Logger_0(&$q, &$type, $v) {
	{
		$GLOBALS['%s']->push("sirius.data.Logger::push@35");
		$__hx__spos2 = $GLOBALS['%s']->length;
		call_user_func_array($v, array($q, $type));
		$GLOBALS['%s']->pop();
	}
}
