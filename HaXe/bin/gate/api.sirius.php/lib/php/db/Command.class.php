<?php

class php_db_Command {
	public function __construct($statement, $arguments) {
		if(!php_Boot::$skip_constructor) {
		$this->statement = $statement;
		if($arguments !== null) {
			$this->bind($arguments);
		}
	}}
	public $success;
	public $statement;
	public $result;
	public function bind($arguments) {
		$_g = $this;
		sirius_utils_Dice::All($arguments, array(new _hx_lambda(array(&$_g, &$arguments), "php_db_Command_0"), 'execute'), null);
		return $this;
	}
	public function execute($handler = null, $parameters = null) {
		$p = null;
		if($parameters !== null) {
			$p = php_Lib::toPhpArray($parameters);
		}
		$this->success = $this->statement->execute($p);
		if($handler !== null) {
			$this->fetch($handler);
		}
		return $this;
	}
	public function fetch($handler = null) {
		{
			$a = $this->statement->fetchAll(2);
			$this->result = new _hx_array($a);
		}
		if($handler !== null) {
			call_user_func_array($handler, array($this->success, $this->result));
		}
		return $this;
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
	function __toString() { return 'php.db.Command'; }
}
function php_db_Command_0(&$_g, &$arguments, $p, $v) {
	{
		$_g->statement->setAttribute($p, $v);
	}
}
