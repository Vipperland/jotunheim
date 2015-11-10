<?php

class sirius_db_Table implements sirius_db_ITable{
	public function __construct($name, $gate) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.db.Table::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_gate = $gate;
		$this->_name = $name;
		$GLOBALS['%s']->pop();
	}}
	public $_name;
	public $_gate;
	public $_description;
	public $description;
	public function get_description() {
		$GLOBALS['%s']->push("sirius.db.Table::get_description");
		$__hx__spos = $GLOBALS['%s']->length;
		if($this->_description === null) {
			$this->_description = $this->_gate->schemaOf($this->_name)->execute(null, null, null)->result;
		}
		{
			$tmp = $this->_description;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public $name;
	public function get_name() {
		$GLOBALS['%s']->push("sirius.db.Table::get_name");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_name;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function create($clausule = null, $parameters = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.Table::create");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->builder->create($this->_name, $clausule, $parameters, $order, $limit)->execute(null, null, null)->result;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function find($fields, $clausule = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.Table::find");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->builder->find($fields, $this->_name, $clausule, $order, $limit)->execute(null, null, null)->result;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function update($clausule = null, $parameters = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.Table::update");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->builder->update($this->_name, $clausule, $parameters, $order, $limit)->execute(null, null, null)->result;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function delete($clausule = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.Table::delete");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->builder->delete($this->_name, $clausule, $order, $limit)->execute(null, null, null)->result;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function getErrors() {
		$GLOBALS['%s']->push("sirius.db.Table::getErrors");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->get_errors();
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
	static $__properties__ = array("get_name" => "get_name","get_description" => "get_description");
	function __toString() { return 'sirius.db.Table'; }
}
