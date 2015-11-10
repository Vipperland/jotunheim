<?php

class sirius_db_Token {
	public function __construct($host, $port, $user, $pass, $db, $options = null) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.db.Token::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->db = $db;
		$this->options = $options;
		$this->pass = $pass;
		$this->user = $user;
		$this->host = "mysql:host=" . _hx_string_or_null($host) . ";port=" . Std::string(sirius_db_Token_0($this, $db, $host, $options, $pass, $port, $user)) . ";dbname=" . _hx_string_or_null($db) . ";charset=UTF8";
		$GLOBALS['%s']->pop();
	}}
	public $options;
	public $db;
	public $pass;
	public $user;
	public $host;
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
	function __toString() { return 'sirius.db.Token'; }
}
function sirius_db_Token_0(&$__hx__this, &$db, &$host, &$options, &$pass, &$port, &$user) {
	{
		$int = $port;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
