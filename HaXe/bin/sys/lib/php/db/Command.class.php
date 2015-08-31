<?php

class php_db_Command {
	public function __construct($statement, $arguments = null) {
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
		$isArray = Std::is($arguments, _hx_qtype("Array"));
		sirius_utils_Dice::All($arguments, array(new _hx_lambda(array(&$_g, &$arguments, &$isArray), "php_db_Command_0"), 'execute'), null);
		return $this;
	}
	public function execute($handler = null, $type = null, $queue = null, $parameters = null) {
		if($type === null) {
			$type = 2;
		}
		$p = null;
		if($parameters !== null) {
			$p = php_Lib::toPhpArray($parameters);
		}
		$this->success = $this->statement->execute($p);
		{
			$a = $this->statement->fetchAll($type);
			$this->result = new _hx_array($a);
		}
		if($handler !== null) {
			$this->fetch($handler);
		}
		if($queue !== null) {
			$this->queue($queue);
		}
		return $this;
	}
	public function fetch($handler) {
		sirius_utils_Dice::Values($this->result, array(new _hx_lambda(array(&$handler), "php_db_Command_1"), 'execute'), null);
		return $this;
	}
	public function queue($name) {
		sirius_Sirius::$cache->add($name, $this->result);
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
function php_db_Command_0(&$_g, &$arguments, &$isArray, $p, $v) {
	{
		if($isArray) {
			$_g->statement->setAttribute($p, $v);
		} else {
			$_g->statement->bindValue($p, $v, null);
		}
	}
}
function php_db_Command_1(&$handler, $v) {
	{
		call_user_func_array($handler, array($v));
	}
}
