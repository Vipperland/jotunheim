<?php

class sirius_signals_Signals implements sirius_signals_ISignals{
	public function __construct($to) {
		if(!php_Boot::$skip_constructor) {
		$this->object = $to;
		$this->reset();
	}}
	public $_l;
	public $object;
	public function _c($n) {
		if(!$this->has($n)) {
			$value = new sirius_signals_Pipe($n, $this);
			$this->_l->{$n} = $value;
		}
		return Reflect::field($this->_l, $n);
	}
	public function has($name) {
		return _hx_has_field($this->_l, $name);
	}
	public function get($name) {
		return $this->_c($name);
	}
	public function remove($name, $handler = null) {
		return $this->_c($name)->remove($handler);
	}
	public function add($name, $handler = null) {
		return $this->_c($name)->add($handler);
	}
	public function call($name, $data = null) {
		if($this->has($name)) {
			$this->get($name)->call($data);
		}
		return $this;
	}
	public function reset() {
		$this->_l = (new _hx_array(array()));
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
	function __toString() { return 'sirius.signals.Signals'; }
}