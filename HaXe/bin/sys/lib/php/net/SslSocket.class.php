<?php

class php_net_SslSocket extends sys_net_Socket {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("php.net.SslSocket::new");
		$__hx__spos = $GLOBALS['%s']->length;
		parent::__construct();
		$this->protocol = "ssl";
		$GLOBALS['%s']->pop();
	}}
	function __toString() { return 'php.net.SslSocket'; }
}
