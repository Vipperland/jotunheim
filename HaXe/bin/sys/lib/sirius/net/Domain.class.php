<?php

class sirius_net_Domain implements sirius_net_IDomain{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_parseURI();
	}}
	public $host;
	public $port;
	public $fragments;
	public $data;
	public $server;
	public $client;
	public $file;
	public $firstFragment;
	public $lastFragment;
	public $params;
	public function _parseURI() {
		$this->data = php_Lib::objectOfAssociativeArray($_SERVER);
		$this->server = _hx_string_or_null(dirname($_SERVER["SCRIPT_FILENAME"])) . "/";
		$this->host = $_SERVER['SERVER_NAME'];
		$this->client = $_SERVER['REMOTE_ADDR'];
		$this->port = $_SERVER['SERVER_PORT'];
		$this->params = $this->_getParams();
		$p = $_SERVER['SCRIPT_NAME'];
		$this->fragments = sirius_tools_Utils::clearArray(_hx_explode("/", $p), null);
		$this->firstFragment = $this->fragment(0, "");
		$this->lastFragment = $this->fragment($this->fragments->length - 1, $this->firstFragment);
		if(_hx_index_of($this->lastFragment, ".", null) !== -1) {
			$this->file = $this->lastFragment;
			$this->fragments->pop();
			$this->lastFragment = $this->fragment($this->fragments->length - 1, $this->firstFragment);
		}
	}
	public function fragment($i, $a = null) {
		if($i >= 0 && $i < $this->fragments->length) {
			return $this->fragments[$i];
		} else {
			return $a;
		}
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
