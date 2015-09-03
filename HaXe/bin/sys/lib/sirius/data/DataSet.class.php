<?php

class sirius_data_DataSet implements sirius_data_IDataSet{
	public function __construct() {}
	public function get($p) { if(!php_Boot::$skip_constructor) {
		return Reflect::field($this, $p);
	}}
	public function set($p, $v) {
		$this->{$p} = $v;
		return $this;
	}
	public function exists($p) {
		return _hx_has_field($this, $p);
	}
	public function clear() {
		$_g = $this;
		sirius_utils_Dice::Params($this, array(new _hx_lambda(array(&$_g), "sirius_data_DataSet_0"), 'execute'), null);
		return $this;
	}
	public function find($v) {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::All($this, array(new _hx_lambda(array(&$r, &$v), "sirius_data_DataSet_1"), 'execute'), null);
		return $r;
	}
	public function index() {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::Params($this, array(new _hx_lambda(array(&$r), "sirius_data_DataSet_2"), 'execute'), null);
		return $r;
	}
	public function values() {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::Values($this, array(new _hx_lambda(array(&$r), "sirius_data_DataSet_3"), 'execute'), null);
		return $r;
	}
	function __toString() { return 'sirius.data.DataSet'; }
}
function sirius_data_DataSet_0(&$_g, $p) {
	{
		Reflect::deleteField($_g, $p);
	}
}
function sirius_data_DataSet_1(&$r, &$v, $p, $x) {
	{
		if($x !== null && _hx_index_of($x, $v, null) !== -1) {
			$r[$r->length] = $p;
		}
	}
}
function sirius_data_DataSet_2(&$r, $p) {
	{
		$r[$r->length] = $p;
	}
}
function sirius_data_DataSet_3(&$r, $v) {
	{
		$r[$r->length] = $v;
	}
}
