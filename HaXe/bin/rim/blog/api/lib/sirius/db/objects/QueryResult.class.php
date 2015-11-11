<?php

class sirius_db_objects_QueryResult implements sirius_db_objects_IQueryResult{
	public function __construct($data) {
		if(!php_Boot::$skip_constructor) {
		if($data !== null) {
			$this->data = $data;
		} else {
			$this->data = (new _hx_array(array()));
		}
	}}
	public $data;
	public function each($handler) {
		sirius_utils_Dice::Values($this->data, array(new _hx_lambda(array(&$handler), "sirius_db_objects_QueryResult_0"), 'execute'), null);
	}
	public function one($i) {
		if($i < $this->data->length) {
			return $this->data[$i];
		} else {
			return null;
		}
	}
	public function first() {
		return $this->one(0);
	}
	public function last() {
		return $this->one($this->data->length - 1);
	}
	public function slice() {
		if($this->data->length > 0) {
			return $this->data->shift();
		} else {
			return null;
		}
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
	function __toString() { return 'sirius.db.objects.QueryResult'; }
}
function sirius_db_objects_QueryResult_0(&$handler, $v) {
	{
		return call_user_func_array($handler, array($v)) === true;
	}
}
