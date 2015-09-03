<?php

class sirius_php_db_Gate implements sirius_php_db_IGate{
	public function __construct() {}
	public $_db;
	public $command;
	public function isOpen() {
		if(!php_Boot::$skip_constructor) {
		return $this->_db !== null;
	}}
	public function open($token) {
		if(!$this->isOpen()) {
			$this->_db = sirius_php_db_pdo_Bridge::open($token->host, $token->user, $token->pass, $token->options);
			$this->command = null;
		}
		return $this;
	}
	public function prepare($query, $parameters = null, $options = null) {
		$this->command = null;
		if($this->isOpen()) {
			$pdo = $this->_db->prepare($query, php_Lib::toPhpArray((($options === null) ? (new _hx_array(array())) : $options)));
			$this->command = new sirius_php_db_Command($pdo, $parameters);
		}
		return $this->command;
	}
	public function fields($table) {
		$_g = $this;
		if(!Std::is($table, _hx_qtype("Array"))) {
			$table = (new _hx_array(array($table)));
		}
		$r = new sirius_data_DataSet();
		sirius_utils_Dice::Values($table, array(new _hx_lambda(array(&$_g, &$r, &$table), "sirius_php_db_Gate_0"), 'execute'), null);
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
	function __toString() { return 'sirius.php.db.Gate'; }
}
function sirius_php_db_Gate_0(&$_g, &$r, &$table, $v) {
	{
		$c = $_g->prepare("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = :table", _hx_anonymous(array("table" => $v)), null)->execute(null, null, null, null);
		$s = (new _hx_array(array()));
		sirius_utils_Dice::Values($c->result, array(new _hx_lambda(array(&$_g, &$c, &$r, &$s, &$table, &$v), "sirius_php_db_Gate_1"), 'execute'), null);
		$r->set($v, $s);
	}
}
function sirius_php_db_Gate_1(&$_g, &$c, &$r, &$s, &$table, &$v, $v1) {
	{
		$s[$s->length] = $v1->COLUMN_NAME;
	}
}
