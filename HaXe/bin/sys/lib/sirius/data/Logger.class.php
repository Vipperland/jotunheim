<?php

class sirius_data_Logger {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_events = (new _hx_array(array((isset($this->trace) ? $this->trace: array($this, "trace")))));
	}}
	public $_bgs;
	public $_events;
	public function silent() {
		if(Lambda::indexOf($this->_events, (isset($this->trace) ? $this->trace: array($this, "trace"))) !== -1) {
			$this->_events->splice(0, 1);
		}
	}
	public function listen($handler) {
		$this->_events[$this->_events->length] = $handler;
	}
	public function push($q, $type) {
		sirius_utils_Dice::Values($this->_events, array(new _hx_lambda(array(&$q, &$type), "sirius_data_Logger_0"), 'execute'), null);
	}
	public function trace($q, $type) {
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
		call_user_func_array($v, array($q, $type));
	}
}
