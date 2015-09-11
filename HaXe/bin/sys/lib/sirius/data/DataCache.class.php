<?php

class sirius_data_DataCache {
	public function __construct($name = null, $expire = null, $path = null) {
		if(!php_Boot::$skip_constructor) {
		$this->name = $name;
		$this->expire = $expire;
		$this->path = $path;
		$this->clear();
	}}
	public $_DB;
	public $path;
	public $expire;
	public $name;
	public function clear() {
		$this->_DB = _hx_anonymous(array());
		return $this;
	}
	public function set($p, $v) {
		$this->_DB->{$p} = $v;
		return $this;
	}
	public function get($id = null) {
		$d = null;
		if($id !== null) {
			$d = Reflect::field($this->_DB, $id);
		} else {
			$d = null;
		}
		if($d === null) {
			$d = _hx_anonymous(array());
			$this->set($id, $d);
		}
		return $d;
	}
	public function save($expire = null) {
		return $this;
	}
	public function load() {
		return $this;
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
	function __toString() { return 'sirius.data.DataCache'; }
}
