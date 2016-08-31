<?php

class sirius_data_DataSet implements sirius_data_IDataSet{
	public function __construct($q = null) {
		if(!php_Boot::$skip_constructor) {
		if($q !== null) {
			$this->_content = $q;
		} else {
			$this->_content = _hx_anonymous(array());
		}
	}}
	public $_content;
	public function get($p) {
		return Reflect::field($this->_content, $p);
	}
	public function set($p, $v) {
		{
			$field = $p;
			$this->_content->{$field} = $v;
		}
		return $this;
	}
	public function hunset($p) {
		Reflect::deleteField($this->_content, $p);
		return $this;
	}
	public function exists($p) {
		$field = $p;
		return _hx_has_field($this->_content, $field);
	}
	public function clear() {
		$this->_content = _hx_anonymous(array());
		return $this;
	}
	public function find($v) {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::All($this->_content, array(new _hx_lambda(array(&$r, &$v), "sirius_data_DataSet_0"), 'execute'), null);
		return $r;
	}
	public function index() {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::Params($this->_content, (isset($r->push) ? $r->push: array($r, "push")), null);
		return $r;
	}
	public function values() {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::Values($this->_content, (isset($r->push) ? $r->push: array($r, "push")), null);
		return $r;
	}
	public function filter($p, $handler = null) {
		$r = new sirius_data_DataSet(null);
		$h = $handler !== null;
		sirius_utils_Dice::All($this->_content, array(new _hx_lambda(array(&$h, &$handler, &$p, &$r), "sirius_data_DataSet_1"), 'execute'), null);
		return $r;
	}
	public function each($handler) {
		sirius_utils_Dice::All($this->_content, $handler, null);
	}
	public function data() {
		return $this->_content;
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
	function __toString() { return 'sirius.data.DataSet'; }
}
function sirius_data_DataSet_0(&$r, &$v, $p, $x) {
	{
		if($x !== null && _hx_index_of($x, $v, null) !== -1) {
			$r[$r->length] = $p;
		}
	}
}
function sirius_data_DataSet_1(&$h, &$handler, &$p, &$r, $p2, $v) {
	{
		if(Std::is($v, _hx_qtype("sirius.data.IDataSet"))) {
			if($v->exists($p)) {
				$r->set($p2, (($h) ? call_user_func_array($handler, array($v)) : $v->get($p)));
			}
		} else {
			if(sirius_data_DataSet_2($__hx__this, $h, $handler, $p, $p2, $r, $v)) {
				$r->set($p2, (($h) ? call_user_func_array($handler, array($v)) : Reflect::field($v, $p)));
			}
		}
	}
}
function sirius_data_DataSet_2(&$__hx__this, &$h, &$handler, &$p, &$p2, &$r, &$v) {
	{
		$field = $p;
		return _hx_has_field($v, $field);
	}
}
