<?php

class sirius_db_objects_DataTable implements sirius_db_objects_IDataTable{
	public function __construct($name, $gate) {
		if(!php_Boot::$skip_constructor) {
		$this->_gate = $gate;
		$this->_name = $name;
		$this->_fields = "*";
	}}
	public $_name;
	public $_gate;
	public $_description;
	public $_fields;
	public $description;
	public function get_description() {
		$_g = $this;
		if(_hx_field($this, "_description") === null) {
			$this->_description = _hx_anonymous(array());
			$r = $this->_gate->schemaOf($this->_name)->execute(null, null, null)->result;
			sirius_utils_Dice::Values($r, array(new _hx_lambda(array(&$_g, &$r), "sirius_db_objects_DataTable_0"), 'execute'), null);
		}
		return $this->_description;
	}
	public $name;
	public function get_name() {
		return $this->_name;
	}
	public function restrict($fields) {
		$this->_fields = $fields;
		return $this;
	}
	public function create($parameters = null, $clausule = null, $order = null, $limit = null) {
		return new sirius_db_objects_QueryResult($this->_gate->builder->create($this->_name, $clausule, $parameters, $order, $limit)->execute(null, null, null)->result);
	}
	public function findAll($clausule = null, $order = null, $limit = null) {
		return new sirius_db_objects_QueryResult($this->_gate->builder->find($this->_fields, $this->_name, $clausule, $order, $limit)->execute(null, null, null)->result);
	}
	public function findOne($clausule = null) {
		return _hx_deref(new sirius_db_objects_QueryResult($this->_gate->builder->find($this->_fields, $this->_name, $clausule, null, sirius_db_Limit::MAX(1))->execute(null, null, null)->result))->first();
	}
	public function update($parameters = null, $clausule = null, $order = null, $limit = null) {
		return new sirius_db_objects_QueryResult($this->_gate->builder->update($this->_name, $clausule, $parameters, $order, $limit)->execute(null, null, null)->result);
	}
	public function delete($clausule = null, $order = null, $limit = null) {
		return new sirius_db_objects_QueryResult($this->_gate->builder->delete($this->_name, $clausule, $order, $limit)->execute(null, null, null)->result);
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
function sirius_db_objects_DataTable_0(&$_g, &$r, $v) {
	{
		$field = $v->COLUMN_NAME;
		$value = new sirius_db_objects_Column($v);
		$_g->_description->{$field} = $value;
	}
}
