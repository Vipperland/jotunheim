<?php

class php_db_Gate {
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
			$this->command = new php_db_Command($pdo, $parameters);
		}
		return $this->command;
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
	function __toString() { return 'php.db.Gate'; }
}
