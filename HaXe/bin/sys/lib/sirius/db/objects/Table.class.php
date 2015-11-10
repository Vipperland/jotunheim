<?php

class sirius_db_objects_Table implements sirius_db_objects_ITable{
	public function __construct($name, $gate) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.db.objects.Table::new");
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
		$GLOBALS['%s']->push("sirius.db.objects.Table::get_description");
		$__hx__spos = $GLOBALS['%s']->length;
		$_g = $this;
		if(_hx_field($this, "_description") === null) {
			$this->_description = _hx_anonymous(array());
			$r = $this->_gate->schemaOf($this->_name)->execute(null, null, null)->result;
			sirius_utils_Dice::Values($r, array(new _hx_lambda(array(&$_g, &$r), "sirius_db_objects_Table_0"), 'execute'), null);
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
		$GLOBALS['%s']->push("sirius.db.objects.Table::get_name");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_name;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function create($clausule = null, $parameters = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.objects.Table::create");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->builder->create($this->_name, $clausule, $parameters, $order, $limit)->execute(null, null, null)->result;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function find($fields, $clausule = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.objects.Table::find");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->builder->find($fields, $this->_name, $clausule, $order, $limit)->execute(null, null, null)->result;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function update($clausule = null, $parameters = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.objects.Table::update");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->builder->update($this->_name, $clausule, $parameters, $order, $limit)->execute(null, null, null)->result;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function delete($clausule = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.objects.Table::delete");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->builder->delete($this->_name, $clausule, $order, $limit)->execute(null, null, null)->result;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function getErrors() {
		$GLOBALS['%s']->push("sirius.db.objects.Table::getErrors");
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
	function __toString() { return 'sirius.db.objects.Table'; }
}
function sirius_db_objects_Table_0(&$_g, &$r, $v) {
	{
		$GLOBALS['%s']->push("sirius.db.objects.Table::get_description@22");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$field = $v->COLUMN_NAME;
		$value = new sirius_db_objects_Column($v);
		$_g->_description->{$field} = $value;
		$GLOBALS['%s']->pop();
	}
}
