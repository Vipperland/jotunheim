<?php

class sirius_db_Gate implements sirius_db_IGate{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_errors = (new _hx_array(array()));
		$this->_tables = _hx_anonymous(array());
		$this->builder = new sirius_db_tools_QueryBuilder($this);
	}}
	public $_db;
	public $_token;
	public $_tables;
	public $_errors;
	public $builder;
	public $command;
	public $errors;
	public function get_errors() {
		return $this->_errors;
	}
	public function isOpen() {
		return $this->_db !== null && $this->get_errors()->length === 0;
	}
	public function open($token) {
		if(!$this->isOpen()) {
			$this->_token = $token;
			try {
				$this->_db = sirius_db_pdo_Bridge::open($token->host, $token->user, $token->pass, $token->options);
			}catch(Exception $__hx__e) {
				$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
				$e = $_ex_;
				{
					_hx_array_assign($this->get_errors(), $this->get_errors()->length, new sirius_errors_Error($e->getCode(), $e->getMessage(), null));
				}
			}
			$this->command = null;
		}
		return $this;
	}
	public function prepare($query, $parameters = null, $options = null) {
		$pdo = null;
		if($this->isOpen()) {
			$pdo = $this->_db->prepare($query, php_Lib::toPhpArray((($options === null) ? (new _hx_array(array())) : $options)));
		}
		$this->command = new sirius_db_tools_Command($pdo, $query, $parameters, $this->_errors);
		return $this->command;
	}
	public function schemaOf($table = null) {
		$r = null;
		if(!Std::is($table, _hx_qtype("Array"))) {
			$table = (new _hx_array(array($table)));
		}
		$tables = (new _hx_array(array()));
		$clausule = sirius_db_Clause::hAND((new _hx_array(array(sirius_db_Clause::EQUAL("TABLE_SCHEMA", $this->_token->db), sirius_db_Clause::hOR($tables)))));
		sirius_utils_Dice::Values($table, array(new _hx_lambda(array(&$clausule, &$r, &$table, &$tables), "sirius_db_Gate_0"), 'execute'), null);
		return $this->builder->find("*", "INFORMATION_SCHEMA.COLUMNS", $clausule, null, null)->execute(null, null, null);
	}
	public function insertedId() {
		return Std::parseInt($this->_db->lastInsertId(null));
	}
	public function table($table) {
		if(!_hx_has_field($this->_tables, $table)) {
			$value = new sirius_db_objects_DataTable($table, $this);
			$this->_tables->{$table} = $value;
		}
		return Reflect::field($this->_tables, $table);
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
	static $__properties__ = array("get_errors" => "get_errors");
	function __toString() { return 'sirius.db.Gate'; }
}
function sirius_db_Gate_0(&$clausule, &$r, &$table, &$tables, $v) {
	{
		$tables[$tables->length] = sirius_db_Clause::EQUAL("TABLE_NAME", $v);
	}
}
