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
			$this->_db = php_db_PDO::open($token->host, $token->user, $token->pass, $token->options);
			$this->command = null;
		}
		return $this;
	}
	public function prepare($query, $parameters, $exec = null, $options = null) {
		if($exec === null) {
			$exec = true;
		}
		$this->command = null;
		if($this->isOpen()) {
			$this->command = new php_db_Command($this->_db->prepare($query, $options), $parameters);
			if($exec) {
				$this->command->execute(null, null);
			}
		}
		return $this;
	}
	public function bind($parameters) {
		if($this->isOpen() && $this->command !== null) {
			$this->command->bind($parameters);
		}
		return $this;
	}
	public function execute($parameters = null) {
		$this->command->execute($parameters, null);
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
