<?php

class sirius_data_DataSet implements sirius_data_IDataSet{
	public function __construct($q = null) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.data.DataSet::new");
		$__hx__spos = $GLOBALS['%s']->length;
		if($q !== null) {
			$this->_content = $q;
		} else {
			$this->_content = _hx_anonymous(array());
		}
		$GLOBALS['%s']->pop();
	}}
	public $_content;
	public function get($p) {
		$GLOBALS['%s']->push("sirius.data.DataSet::get");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = Reflect::field($this->_content, $p);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function set($p, $v) {
		$GLOBALS['%s']->push("sirius.data.DataSet::set");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_content->{$p} = $v;
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function hunset($p) {
		$GLOBALS['%s']->push("sirius.data.DataSet::unset");
		$__hx__spos = $GLOBALS['%s']->length;
		Reflect::deleteField($this->_content, $p);
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function exists($p) {
		$GLOBALS['%s']->push("sirius.data.DataSet::exists");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_has_field($this->_content, $p);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function clear() {
		$GLOBALS['%s']->push("sirius.data.DataSet::clear");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_content = _hx_anonymous(array());
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function find($v) {
		$GLOBALS['%s']->push("sirius.data.DataSet::find");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = (new _hx_array(array()));
		sirius_utils_Dice::All($this->_content, array(new _hx_lambda(array(&$r, &$v), "sirius_data_DataSet_0"), 'execute'), null);
		{
			$GLOBALS['%s']->pop();
			return $r;
		}
		$GLOBALS['%s']->pop();
	}
	public function index() {
		$GLOBALS['%s']->push("sirius.data.DataSet::index");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = (new _hx_array(array()));
		sirius_utils_Dice::Params($this->_content, (isset($r->push) ? $r->push: array($r, "push")), null);
		{
			$GLOBALS['%s']->pop();
			return $r;
		}
		$GLOBALS['%s']->pop();
	}
	public function values() {
		$GLOBALS['%s']->push("sirius.data.DataSet::values");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = (new _hx_array(array()));
		sirius_utils_Dice::Values($this->_content, (isset($r->push) ? $r->push: array($r, "push")), null);
		{
			$GLOBALS['%s']->pop();
			return $r;
		}
		$GLOBALS['%s']->pop();
	}
	public function filter($p, $handler = null) {
		$GLOBALS['%s']->push("sirius.data.DataSet::filter");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = new sirius_data_DataSet(null);
		$h = $handler !== null;
		sirius_utils_Dice::All($this->_content, array(new _hx_lambda(array(&$h, &$handler, &$p, &$r), "sirius_data_DataSet_1"), 'execute'), null);
		{
			$GLOBALS['%s']->pop();
			return $r;
		}
		$GLOBALS['%s']->pop();
	}
	public function each($handler) {
		$GLOBALS['%s']->push("sirius.data.DataSet::each");
		$__hx__spos = $GLOBALS['%s']->length;
		sirius_utils_Dice::All($this->_content, $handler, null);
		$GLOBALS['%s']->pop();
	}
	public function structure() {
		$GLOBALS['%s']->push("sirius.data.DataSet::structure");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_content;
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
	function __toString() { return 'sirius.data.DataSet'; }
}
function sirius_data_DataSet_0(&$r, &$v, $p, $x) {
	{
		$GLOBALS['%s']->push("sirius.data.DataSet::find@44");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if($x !== null && _hx_index_of($x, $v, null) !== -1) {
			$r[$r->length] = $p;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_data_DataSet_1(&$h, &$handler, &$p, &$r, $p2, $v) {
	{
		$GLOBALS['%s']->push("sirius.data.DataSet::filter@65");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if(Std::is($v, _hx_qtype("sirius.data.IDataSet"))) {
			if($v->exists($p)) {
				$r->set($p2, (($h) ? call_user_func_array($handler, array($v)) : $v->get($p)));
			}
		} else {
			if(_hx_has_field($v, $p)) {
				$r->set($p2, (($h) ? call_user_func_array($handler, array($v)) : Reflect::field($v, $p)));
			}
		}
		$GLOBALS['%s']->pop();
	}
}
