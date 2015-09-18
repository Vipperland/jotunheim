<?php

class sirius_db_Gate implements sirius_db_IGate{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->errors = (new _hx_array(array()));
	}}
	public $_db;
	public $command;
	public $_token;
	public $errors;
	public function isOpen() {
		return $this->_db !== null && $this->errors->length === 0;
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
					php_Lib::dump($e);
					$this->errors[$this->errors->length] = new sirius_errors_Error($e->getCode(), $e->getMessage());
				}
			}
			$this->command = null;
		}
		return $this;
	}
	public function prepare($query, $parameters = null, $options = null) {
		$this->command = null;
		if($this->isOpen()) {
			$pdo = $this->_db->prepare($query, php_Lib::toPhpArray((($options === null) ? (new _hx_array(array())) : $options)));
			$this->command = new sirius_db_Command($pdo, $query, $parameters);
		}
		return $this->command;
	}
	public function insert($table, $parameters, $options = null) {
		$ps = (new _hx_array(array()));
		sirius_utils_Dice::All($parameters, (isset($ps->push) ? $ps->push: array($ps, "push")), null);
		return $this->prepare("INSERT INTO " . _hx_string_or_null($table) . " (" . _hx_string_or_null($ps->join(",")) . ") VALUES (:" . _hx_string_or_null($ps->join(",:")) . ")", $parameters, $options);
	}
	public function schemaOf($table = null) {
		$_g = $this;
		$r = null;
		if($this->isOpen()) {
			if(!Std::is($table, _hx_qtype("Array"))) {
				$table = (new _hx_array(array($table)));
			}
			$r = new sirius_data_DataSet(null);
			sirius_utils_Dice::Values($table, array(new _hx_lambda(array(&$_g, &$r, &$table), "sirius_db_Gate_0"), 'execute'), null);
		}
		return $r;
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
	function __toString() { return 'sirius.db.Gate'; }
}
function sirius_db_Gate_0(&$_g, &$r, &$table, $v) {
	{
		$c = $_g->prepare("SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = :schema AND TABLE_NAME = :table", _hx_anonymous(array("schema" => $_g->_token->db, "table" => $v)), null)->execute(null, null, null, null);
		$s = new sirius_data_DataSet(null);
		sirius_utils_Dice::All($c->result, (isset($s->set) ? $s->set: array($s, "set")), null);
		$r->set($v, $s);
	}
}
