<?php

class sirius_db_Command implements sirius_db_ICommand{
	public function __construct($statement, $query, $parameters = null) {
		if(!php_Boot::$skip_constructor) {
		$this->errors = (new _hx_array(array()));
		$this->_parameters = _hx_anonymous(array());
		$this->_query = $query;
		$this->statement = $statement;
		if($parameters !== null) {
			$this->bind($parameters);
		}
	}}
	public $_query;
	public $_parameters;
	public $success;
	public $statement;
	public $result;
	public $errors;
	public function bind($parameters) {
		$_g = $this;
		$isArray = Std::is($parameters, _hx_qtype("Array"));
		sirius_utils_Dice::All($parameters, array(new _hx_lambda(array(&$_g, &$isArray, &$parameters), "sirius_db_Command_0"), 'execute'), null);
		return $this;
	}
	public function execute($handler = null, $type = null, $parameters = null) {
		if($type === null) {
			$type = 2;
		}
		$p = null;
		if($parameters !== null) {
			$p = php_Lib::toPhpArray($parameters);
		}
		try {
			$this->success = $this->statement->execute($p);
			{
				$a = $this->statement->fetchAll($type);
				$this->result = new _hx_array($a);
			}
			if($handler !== null) {
				$this->fetch($handler);
			}
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			$e = $_ex_;
			{
				$this->errors[$this->errors->length] = new sirius_errors_Error($e->getCode(), $e->getMessage());
			}
		}
		return $this;
	}
	public function fetch($handler) {
		sirius_utils_Dice::Values($this->result, array(new _hx_lambda(array(&$handler), "sirius_db_Command_1"), 'execute'), null);
		return $this;
	}
	public function log() {
		$q = $this->_query;
		sirius_utils_Dice::All($this->_parameters, array(new _hx_lambda(array(&$q), "sirius_db_Command_2"), 'execute'), null);
		return $q;
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
	function __toString() { return 'sirius.db.Command'; }
}
function sirius_db_Command_0(&$_g, &$isArray, &$parameters, $p, $v) {
	{
		if($isArray) {
			$_g->statement->setAttribute($p, $v);
		} else {
			$_g->statement->bindValue($p, $v, null);
		}
		{
			$field = $p;
			$_g->_parameters->{$field} = $v;
		}
	}
}
function sirius_db_Command_1(&$handler, $v) {
	{
		call_user_func_array($handler, array(new sirius_data_DataSet($v)));
	}
}
function sirius_db_Command_2(&$q, $p, $v) {
	{
		$sub = ":" . _hx_string_or_null($p);
		$by = $v;
		if($sub === "") {
			$q = implode(str_split ($q), $by);
		} else {
			$q = str_replace($sub, $by, $q);
		}
	}
}
