<?php

class sirius_db_Gate implements sirius_db_IGate{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.db.Gate::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_errors = (new _hx_array(array()));
		$this->_tables = _hx_anonymous(array());
		$this->builder = new sirius_db_tools_QueryBuilder($this);
		$GLOBALS['%s']->pop();
	}}
	public $_db;
	public $_token;
	public $_tables;
	public $_errors;
	public $builder;
	public $command;
	public $errors;
	public function get_errors() {
		$GLOBALS['%s']->push("sirius.db.Gate::get_errors");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_errors;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function isOpen() {
		$GLOBALS['%s']->push("sirius.db.Gate::isOpen");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_db !== null && $this->get_errors()->length === 0;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function open($token) {
		$GLOBALS['%s']->push("sirius.db.Gate::open");
		$__hx__spos = $GLOBALS['%s']->length;
		if(!$this->isOpen()) {
			$this->_token = $token;
			try {
				$this->_db = sirius_db_pdo_Bridge::open($token->host, $token->user, $token->pass, $token->options);
			}catch(Exception $__hx__e) {
				$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
				$e = $_ex_;
				{
					$GLOBALS['%e'] = (new _hx_array(array()));
					while($GLOBALS['%s']->length >= $__hx__spos) {
						$GLOBALS['%e']->unshift($GLOBALS['%s']->pop());
					}
					$GLOBALS['%s']->push($GLOBALS['%e'][0]);
					_hx_array_assign($this->get_errors(), $this->get_errors()->length, new sirius_errors_Error($e->getCode(), $e->getMessage(), null));
				}
			}
			$this->command = null;
		}
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function prepare($query, $parameters = null, $options = null) {
		$GLOBALS['%s']->push("sirius.db.Gate::prepare");
		$__hx__spos = $GLOBALS['%s']->length;
		$pdo = null;
		if($this->isOpen()) {
			$pdo = $this->_db->prepare($query, php_Lib::toPhpArray((($options === null) ? (new _hx_array(array())) : $options)));
		}
		$this->command = new sirius_db_tools_Command($pdo, $query, $parameters, $this->_errors);
		{
			$tmp = $this->command;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function schemaOf($table = null) {
		$GLOBALS['%s']->push("sirius.db.Gate::schemaOf");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = null;
		if(!Std::is($table, _hx_qtype("Array"))) {
			$table = (new _hx_array(array($table)));
		}
		$tables = (new _hx_array(array()));
		$clausule = sirius_db_Clause::hAND((new _hx_array(array(sirius_db_Clause::EQUAL("TABLE_SCHEMA", $this->_token->db), sirius_db_Clause::hOR($tables)))));
		sirius_utils_Dice::Values($table, array(new _hx_lambda(array(&$clausule, &$r, &$table, &$tables), "sirius_db_Gate_0"), 'execute'), null);
		{
			$tmp = $this->builder->find("*", "INFORMATION_SCHEMA.COLUMNS", $clausule, null, null)->execute(null, null, null);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function insertedId() {
		$GLOBALS['%s']->push("sirius.db.Gate::insertedId");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = Std::parseInt($this->_db->lastInsertId(null));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function getTable($table) {
		$GLOBALS['%s']->push("sirius.db.Gate::getTable");
		$__hx__spos = $GLOBALS['%s']->length;
		if(!_hx_has_field($this->_tables, $table)) {
			$value = new sirius_db_objects_DataTable($table, $this);
			$this->_tables->{$table} = $value;
		}
		{
			$tmp = Reflect::field($this->_tables, $table);
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
	static $__properties__ = array("get_errors" => "get_errors");
	function __toString() { return 'sirius.db.Gate'; }
}
function sirius_db_Gate_0(&$clausule, &$r, &$table, &$tables, $v) {
	{
		$GLOBALS['%s']->push("sirius.db.Gate::schemaOf@85");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$tables[$tables->length] = sirius_db_Clause::EQUAL("TABLE_NAME", $v);
		$GLOBALS['%s']->pop();
	}
}
