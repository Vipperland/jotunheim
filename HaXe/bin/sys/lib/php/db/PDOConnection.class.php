<?php

class php_db_PDOConnection implements sys_db_Connection{
	public function __construct($dsn, $user = null, $password = null, $options = null) {
		if(!php_Boot::$skip_constructor) {
		if(null === $options) {
			$this->pdo = new PDO($dsn, $user, $password);
		} else {
			$arr = array();
			{
				$_g = 0;
				$_g1 = Reflect::fields($options);
				while($_g < $_g1->length) {
					$key = $_g1[$_g];
					++$_g;
					$arr[$key] = Reflect::field($options, $key);
					unset($key);
				}
			}
			$this->pdo = new PDO($dsn, $user, $password, $arr);
		}
		$this->dbname = _hx_explode(":", $dsn)->shift();
		{
			$_g2 = strtolower($this->dbname);
			switch($_g2) {
			case "sqlite":{
				$this->dbname = "SQLite";
			}break;
			case "mysql":{
				$this->dbname = "MySQL";
			}break;
			}
		}
	}}
	public $pdo;
	public $dbname;
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
	function __toString() { return 'php.db.PDOConnection'; }
}
