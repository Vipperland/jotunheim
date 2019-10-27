<?php

// Generated by Haxe 3.4.7
class jotun_db_objects_DataTable implements jotun_db_objects_IDataTable{
	public function __construct($name, $gate) {
		if(!php_Boot::$skip_constructor) {
		$this->_gate = $gate;
		$this->_name = $name;
		$this->_fields = "*";
		$this->_restrict = 0;
	}}
	public $_name;
	public $_gate;
	public $_fields;
	public $_class;
	public $_info;
	public $_restrict;
	public function _checkRestriction() {
		$r = $this->_fields;
		$tmp = null;
		$a = $this->_restrict;
		$aNeg = $a < 0;
		$bNeg = 0 < 0;
		$tmp1 = null;
		if($aNeg !== $bNeg) {
			$tmp1 = $aNeg;
		} else {
			$tmp1 = $a > 0;
		}
		if($tmp1) {
			$tmp = --$this->_restrict === 0;
		} else {
			$tmp = false;
		}
		if($tmp) {
			$this->unrestrict();
		}
		return $r;
	}
	public function getInfo() {
		$_gthis = $this;
		haxe_Log::trace(1, _hx_anonymous(array("fileName" => "DataTable.hx", "lineNumber" => 33, "className" => "jotun.db.objects.DataTable", "methodName" => "getInfo")));
		if(_hx_field($this, "_info") === null) {
			$this->_info = _hx_anonymous(array());
			$r = $this->_gate->schema($this->_name);
			jotun_utils_Dice::Values($r, array(new _hx_lambda(array(&$_gthis), "jotun_db_objects_DataTable_0"), 'execute'), null);
		}
		return $this->_info;
	}
	public $name;
	public function get_name() {
		return $this->_name;
	}
	public function getAutoIncrement() {
		$cmd = $this->_gate->builder;
		$cmd1 = jotun_db_Clause::EQUAL("TABLE_SCHEMA", $this->_gate->getName());
		$cmd2 = jotun_db_Clause::hAND((new _hx_array(array($cmd1, jotun_db_Clause::EQUAL("TABLE_NAME", $this->_name)))));
		$cmd3 = jotun_db_Limit::MAX(1);
		$cmd4 = $cmd->find("AUTO_INCREMENT", "INFORMATION_SCHEMA.TABLES", $cmd2, null, $cmd3)->execute(null, null, null);
		$tmp = null;
		if($cmd4->result !== null) {
			$tmp = $cmd4->result->length > 0;
		} else {
			$tmp = false;
		}
		if($tmp) {
			return Std::parseInt(_hx_field($cmd4->result[0], "AUTO_INCREMENT"));
		} else {
			return 0;
		}
	}
	public function setClassObj($value) {
		$this->_class = $value;
		return $this;
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
	public function addAll($parameters = null, $clause = null, $order = null, $limit = null) {
		$_gthis = $this;
		$r = (new _hx_array(array()));
		jotun_utils_Dice::All($parameters, array(new _hx_lambda(array(&$_gthis, &$clause, &$limit, &$order, &$parameters, &$r), "jotun_db_objects_DataTable_1"), 'execute'), null);
		return $r;
	}
	public function add($parameters = null, $clause = null, $order = null, $limit = null) {
		return new jotun_db_objects_Query($this, $this->_gate->builder->add($this->_name, $clause, $parameters, $order, $limit)->execute(null, null, null)->success);
	}
	public function findAll($clause = null, $order = null, $limit = null) {
		$tmp = $this->_gate->builder;
		$tmp1 = $this->_checkRestriction();
		return new jotun_db_objects_ExtQuery($this, $tmp->find($tmp1, $this->_name, $clause, $order, $limit)->execute(null, $this->_class, null)->result);
	}
	public function findOne($clause = null, $order = null) {
		$tmp = $this->_gate->builder;
		$tmp1 = $this->_checkRestriction();
		return _hx_deref(new jotun_db_objects_ExtQuery($this, $tmp->find($tmp1, $this->_name, $clause, $order, jotun_db_Limit::$ONE)->execute(null, $this->_class, null)->result))->first();
	}
	public function update($parameters = null, $clause = null, $order = null, $limit = null) {
		return new jotun_db_objects_Query($this, $this->_gate->builder->update($this->_name, $clause, $parameters, $order, $limit)->execute(null, null, null)->success);
	}
	public function updateOne($parameters = null, $clause = null, $order = null) {
		return new jotun_db_objects_Query($this, $this->_gate->builder->update($this->_name, $clause, $parameters, $order, jotun_db_Limit::$ONE)->execute(null, null, null)->success);
	}
	public function delete($clause = null, $order = null, $limit = null) {
		return new jotun_db_objects_Query($this, $this->_gate->builder->delete($this->_name, $clause, $order, $limit)->execute(null, null, null)->success);
	}
	public function deleteOne($clause = null, $order = null) {
		return new jotun_db_objects_Query($this, $this->_gate->builder->delete($this->_name, $clause, $order, jotun_db_Limit::$ONE)->execute(null, null, null)->success);
	}
	public function copy($toTable, $clause = null, $order = null, $limit = null) {
		return new jotun_db_objects_ExtQuery($this, $this->_gate->builder->copy($this->_name, $toTable, $clause, $order, $limit));
	}
	public function copyOne($toTable, $clause = null, $order = null) {
		return new jotun_db_objects_ExtQuery($this, _hx_array_get($this->_gate->builder->copy($this->_name, $toTable, $clause, $order, jotun_db_Limit::$ONE), 0));
	}
	public function clear() {
		return new jotun_db_objects_Query($this, $this->_gate->builder->truncate($this->_name)->success);
	}
	public function rename($to) {
		$old = $this->_name;
		$this->_name = $to;
		return new jotun_db_objects_Query($this, $this->_gate->builder->rename($old, $to)->success);
	}
	public function length($clause = null, $limit = null) {
		return $this->_gate->builder->find("COUNT(*)", $this->_name, $clause, null, $limit)->execute(null, null, null)->length(null);
	}
	public function exists($clause = null) {
		$a = $this->length($clause, jotun_db_Limit::$ONE);
		$aNeg = $a < 0;
		$bNeg = 0 < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return $a > 0;
		}
	}
	public function sum($field, $clause = null) {
		$command = $this->_gate->builder->find("SUM(" . _hx_string_or_null($field) . ") as _SumResult_", $this->_name, $clause, null, null)->execute(null, null, null);
		$tmp = null;
		if($command->result->length > 0) {
			$tmp = Std::parseInt(Reflect::field($command->result[0], "_SumResult_"));
		} else {
			$tmp = 0;
		}
		return jotun_tools_Utils::getValidOne($tmp, 0);
	}
	public function optimize($paramaters) {
		$desc = $this->getInfo();
		jotun_utils_Dice::All($paramaters, array(new _hx_lambda(array(&$desc, &$paramaters), "jotun_db_objects_DataTable_2"), 'execute'), null);
		return $paramaters;
	}
	public function link($id, $key, $table, $field, $del = null, $update = null) {
		if($update === null) {
			$update = "RESTRICT";
		}
		if($del === null) {
			$del = "RESTRICT";
		}
		return $this->_gate->builder->fKey($this->_name, $id, $key, $table, $field, $del, $update)->execute(null, null, null);
	}
	public function unlink($id) {
		return $this->_gate->builder->fKey($this->_name, $id, null, null, null, null, null)->execute(null, null, null);
	}
	public function hasColumn($name) {
		$o = $this->getInfo();
		return _hx_has_field($o, $name);
	}
	public function getColumn($name) {
		if($this->hasColumn($name)) {
			return Reflect::field($this->getInfo(), $name);
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
	static $__properties__ = array("get_name" => "get_name");
	function __toString() { return 'jotun.db.objects.DataTable'; }
}
function jotun_db_objects_DataTable_0(&$_gthis, $v) {
	{
		$o = $_gthis->_info;
		$field = _hx_field($v, "COLUMN_NAME");
		$value = new jotun_db_objects_Column($v);
		$o->{$field} = $value;
	}
}
function jotun_db_objects_DataTable_1(&$_gthis, &$clause, &$limit, &$order, &$parameters, &$r, $v) {
	{
		$r1 = $r->length;
		$tmp = $_gthis->add($parameters, $clause, $order, $limit);
		$r[$r1] = $tmp;
	}
}
function jotun_db_objects_DataTable_2(&$desc, &$paramaters, $p, $v) {
	{
		if(!_hx_has_field($desc, $p)) {
			Reflect::deleteField($paramaters, $p);
		}
	}
}