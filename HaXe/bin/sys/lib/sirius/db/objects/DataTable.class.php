<?php

class sirius_db_objects_DataTable implements sirius_db_objects_IDataTable{
	public function __construct($name, $gate) {
		if(!php_Boot::$skip_constructor) {
		$this->_gate = $gate;
		$this->_name = $name;
		$this->_fields = "*";
		$this->_restrict = 0;
	}}
	public $_name;
	public $_gate;
	public $_description;
	public $_fields;
	public $_restrict;
	public function _checkRestriction() {
		$r = $this->_fields;
		if(sirius_db_objects_DataTable_0($this, $r) && sirius_db_objects_DataTable_1($this, $r)) {
			$this->unrestrict();
		}
		return $r;
	}
	public $description;
	public function get_description() {
		$_g = $this;
		if(_hx_field($this, "_description") === null) {
			$this->_description = _hx_anonymous(array());
			$r = $this->_gate->schema($this->_name)->execute(null, null, null)->result;
			sirius_utils_Dice::Values($r, array(new _hx_lambda(array(&$_g, &$r), "sirius_db_objects_DataTable_2"), 'execute'), null);
		}
		return $this->_description;
	}
	public $name;
	public function get_name() {
		return $this->_name;
	}
	public function restrict($fields, $times = null) {
		if($times === null) {
			$times = 0;
		}
		$this->_restrict = $times;
		$this->_fields = $fields;
		return $this;
	}
	public function unrestrict() {
		$this->_fields = "*";
		return $this;
	}
	public function add($parameters = null, $clausule = null, $order = null, $limit = null) {
		return new sirius_db_objects_QueryResult($this->_gate->builder->add($this->_name, $clausule, $parameters, $order, $limit)->execute(null, null, null)->result);
	}
	public function findAll($clausule = null, $order = null, $limit = null) {
		return new sirius_db_objects_QueryResult($this->_gate->builder->find($this->_checkRestriction(), $this->_name, $clausule, $order, $limit)->execute(null, null, null)->result);
	}
	public function findOne($clausule = null) {
		return _hx_deref(new sirius_db_objects_QueryResult($this->_gate->builder->find($this->_checkRestriction(), $this->_name, $clausule, null, sirius_db_Limit::MAX(1))->execute(null, null, null)->result))->first();
	}
	public function update($parameters = null, $clausule = null, $order = null, $limit = null) {
		return new sirius_db_objects_QueryResult($this->_gate->builder->update($this->_name, $clausule, $parameters, $order, $limit)->execute(null, null, null)->result);
	}
	public function delete($clausule = null, $order = null, $limit = null) {
		return new sirius_db_objects_QueryResult($this->_gate->builder->delete($this->_name, $clausule, $order, $limit)->execute(null, null, null)->result);
	}
	public function copy($toTable, $clausule = null, $order = null, $limit = null) {
		return new sirius_db_objects_QueryResult($this->_gate->builder->copy($this->_name, $toTable, $clausule, $order, $limit)->execute(null, null, null)->result);
	}
	public function truncate() {
		return new sirius_db_objects_QueryResult($this->_gate->builder->truncate($this->_name)->result);
	}
	public function rename($to) {
		$old = $this->_name;
		$this->_name = $to;
		return new sirius_db_objects_QueryResult($this->_gate->builder->rename($old, $to)->result);
	}
	public function length() {
		$command = $this->_gate->prepare("SELECT COUNT(*) FROM " . _hx_string_or_null($this->_name), null, null)->execute(null, null, null);
		if($command->result->length > 0) {
			return Std::parseInt(Reflect::field($command->result[0], "COUNT(*)"));
		} else {
			return 0;
		}
	}
	public function clear($paramaters) {
		$desc = $this->get_description();
		sirius_utils_Dice::All($paramaters, array(new _hx_lambda(array(&$desc, &$paramaters), "sirius_db_objects_DataTable_3"), 'execute'), null);
		return $paramaters;
	}
	public function hasColumn($name) {
		$d = $this->get_description();
		return _hx_has_field($d, $name);
	}
	public function getColumn($name) {
		if($this->hasColumn($name)) {
			return Reflect::field($this->_description, $name);
		} else {
			return null;
		}
	}
	public function getErrors() {
		return $this->_gate->get_errors();
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
	static $__properties__ = array("get_name" => "get_name","get_description" => "get_description");
	function __toString() { return 'sirius.db.objects.DataTable'; }
}
function sirius_db_objects_DataTable_0(&$__hx__this, &$r) {
	{
		$a = $__hx__this->_restrict;
		$aNeg = $a < 0;
		$bNeg = 0 < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return $a > 0;
		}
		unset($bNeg,$aNeg,$a);
	}
}
function sirius_db_objects_DataTable_1(&$__hx__this, &$r) {
	{
		$a1 = --$__hx__this->_restrict;
		return $a1 === 0;
	}
}
function sirius_db_objects_DataTable_2(&$_g, &$r, $v) {
	{
		$field = $v->COLUMN_NAME;
		$value = new sirius_db_objects_Column($v);
		$_g->_description->{$field} = $value;
	}
}
function sirius_db_objects_DataTable_3(&$desc, &$paramaters, $p, $v) {
	{
		if(!_hx_has_field($desc, $p)) {
			Reflect::deleteField($paramaters, $p);
		}
	}
}
