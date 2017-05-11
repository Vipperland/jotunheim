<?php

class sirius_db_objects_TableObject implements sirius_db_objects_ITableObject{
	public function __construct($table, $data = null) {
		if(!php_Boot::$skip_constructor) {
		$this->_table = $table;
		if($data !== null) {
			$this->data = $data;
		}
	}}
	public $_table;
	public $id;
	public function get_id() {
		if(_hx_field($this, "data") !== null) {
			return $this->data->id;
		} else {
			return null;
		}
	}
	public $data;
	public function create($data, $verify = null) {
		if($verify === null) {
			$verify = false;
		}
		$data->created_at = sirius_Sirius::$tick;
		$data->updated_at = sirius_Sirius::$tick;
		if($verify) {
			$this->_table->optimize($data);
		}
		$this->_table->add($data, null, null, null);
		$this->data = $data;
		$data->id = sirius_Sirius::$gate->insertedId();
		return $this;
	}
	public function update($data, $verify = null) {
		if($verify === null) {
			$verify = false;
		}
		$data->updated_at = sirius_Sirius::$tick;
		if($verify) {
			$this->_table->optimize($data);
		}
		$this->_table->update($data, sirius_db_Clause::ID($this->get_id()), null, sirius_db_Limit::$ONE);
	}
	public function copy() {
		$obj = new sirius_db_objects_TableObject($this->_table, null);
		$newdata = clone($this->data);
		Reflect::deleteField($newdata, "id");
		return $obj->create($newdata, null);
	}
	public function delete() {
		$this->_table->delete(sirius_db_Clause::ID($this->get_id()), null, sirius_db_Limit::$ONE);
		$this->_table = null;
		$this->data = null;
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
	static $PROPERTIES;
	static function GetProperties() {
		return STATIC::$PROPERTIES;
	}
	static $__properties__ = array("get_id" => "get_id");
	function __toString() { return 'sirius.db.objects.TableObject'; }
}
sirius_db_objects_TableObject::$PROPERTIES = (new _hx_array(array("id", "updated_at", "created_at")));
