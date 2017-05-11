<?php

class sirius_net_DefHeader implements sirius_net_IDefHeader{
	public function __construct($data) {}
	public $ContentType;
	public $ContentLength;
	public function _parse($data) {
		if(!php_Boot::$skip_constructor) {
		$_g = $this;
		sirius_utils_Dice::All(sirius_Sirius::$domain->data, array(new _hx_lambda(array(&$_g, &$data), "sirius_net_DefHeader_0"), 'execute'), null);
	}}
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
	function __toString() { return 'sirius.net.DefHeader'; }
}
function sirius_net_DefHeader_0(&$_g, &$data, $p, $v) {
	{
		if(_hx_substr($p, 0, 5) === "HTTP_") {} else {
			if($p === "CONTENT_TYPE") {
				$_g->ContentType = $v;
			} else {
				if($p === "CONTENT_LENGTH") {
					$_g->ContentLength = Std::parseInt($v);
				}
			}
		}
	}
}
