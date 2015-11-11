<?php

class sirius_net_Domain implements sirius_net_IDomain{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_parseURI();
	}}
	public $host;
	public $port;
	public $url;
	public $data;
	public $server;
	public $client;
	public $file;
	public $params;
	public function _parseURI() {
		$this->data = php_Lib::objectOfAssociativeArray($_SERVER);
		$this->server = _hx_string_or_null(dirname($_SERVER["SCRIPT_FILENAME"])) . "/";
		$this->host = $_SERVER['SERVER_NAME'];
		$this->client = $_SERVER['REMOTE_ADDR'];
		$this->port = $_SERVER['SERVER_PORT'];
		$this->params = $this->_getParams();
		$p = $_SERVER['SCRIPT_NAME'];
		$this->url = new sirius_data_Fragments($p, "/");
	}
	public function hrequire($params) {
		$_g = $this;
		$r = true;
		sirius_utils_Dice::Values($params, array(new _hx_lambda(array(&$_g, &$params, &$r), "sirius_net_Domain_0"), 'execute'), null);
		return $r;
	}
	public function _getParams() {
		$a = array_merge($_GET, $_POST);
		if(get_magic_quotes_gpc()) {
			reset($a); while(list($k, $v) = each($a)) $a[$k] = stripslashes((string)$v);
		}
		return php_Lib::objectOfAssociativeArray($a);
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
	function __toString() { return 'sirius.net.Domain'; }
}
function sirius_net_Domain_0(&$_g, &$params, &$r, $v) {
	{
		$r = _hx_has_field($_g->params, $v);
		return !$r;
	}
}
