<?php

class php_db_Gate {
	public function __construct() {}
	public function open($token) { if(!php_Boot::$skip_constructor) {
		return $this;
	}}
	function __toString() { return 'php.db.Gate'; }
}
