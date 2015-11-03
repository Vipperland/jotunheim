<?php

class sirius_php_net_Mailer {
	public function __construct($url, $user, $password, $secure = null, $port = null) {
		if(!php_Boot::$skip_constructor) {
		if($port === null) {
			$port = 587;
		}
		sirius_Sirius::hrequire("PHPMailer/PHPMailerAutoload.php");
		$this->output = new PHPMailer();
		$this->get_output()->CharSet = "UTF-8";
		$this->get_output()->isSMTP();
		$this->get_output()->isHTML(true);
		$this->setAuth($url, $user, $password, $secure, $port);
	}}
	public $output;
	public function origin($name, $email) {
		if($email !== null) {
			$this->get_output()->From = $email;
		}
		if($name !== null) {
			$this->get_output()->FromName = $name;
		}
	}
	public function debug($level) {
		$this->get_output()->SMTPDebug = $level;
	}
	public function setAuth($url, $user, $password, $secure = null, $port = null) {
		if($port === null) {
			$port = 587;
		}
		$this->get_output()->Host = $url;
		$this->get_output()->Username = $user;
		$this->get_output()->Password = $password;
		$this->get_output()->Port = $port;
		if($secure !== null) {
			$this->get_output()->SMTPSecure = $secure;
		}
	}
	public function targets($to, $cc = null, $bbc = null) {
		$_g = $this;
		sirius_utils_Dice::Values($to, array(new _hx_lambda(array(&$_g, &$bbc, &$cc, &$to), "sirius_php_net_Mailer_0"), 'execute'), null);
		sirius_utils_Dice::Values($cc, array(new _hx_lambda(array(&$_g, &$bbc, &$cc, &$to), "sirius_php_net_Mailer_1"), 'execute'), null);
		sirius_utils_Dice::Values($bbc, array(new _hx_lambda(array(&$_g, &$bbc, &$cc, &$to), "sirius_php_net_Mailer_2"), 'execute'), null);
	}
	public function message($subject, $text) {
		$this->get_output()->Subject = $subject;
		$this->get_output()->Body = $text;
		$this->get_output()->AltBody = _hx_explode("<br/>", _hx_explode("<br>", $text)->join(""))->join("");
	}
	public function getError() {
		return $this->get_output()->ErrorInfo;
	}
	public function send() {
		return $this->get_output()->send();
	}
	public function get_output() {
		return $this->output;
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
	static function target($name, $mail) {
		return _hx_string_or_null($mail) . "|" . _hx_string_or_null($name);
	}
	static $__properties__ = array("get_output" => "get_output");
	function __toString() { return 'sirius.php.net.Mailer'; }
}
function sirius_php_net_Mailer_0(&$_g, &$bbc, &$cc, &$to, $v) {
	{
		if(Std::is($v, _hx_qtype("Array")) && sirius_tools_Utils::isValid($v[0])) {
			$_g->get_output()->addAddress($v[0], $v[1]);
		} else {
			if(sirius_tools_Utils::isValid($v)) {
				$_g->get_output()->addAddress($v, null);
			}
		}
	}
}
function sirius_php_net_Mailer_1(&$_g, &$bbc, &$cc, &$to, $v1) {
	{
		if(Std::is($v1, _hx_qtype("Array")) && sirius_tools_Utils::isValid($v1[0])) {
			$_g->get_output()->addCC($v1[0], $v1[1]);
		} else {
			if(sirius_tools_Utils::isValid($v1)) {
				$_g->get_output()->addCC($v1, null);
			}
		}
	}
}
function sirius_php_net_Mailer_2(&$_g, &$bbc, &$cc, &$to, $v2) {
	{
		if(Std::is($v2, _hx_qtype("Array")) && sirius_tools_Utils::isValid($v2[0])) {
			$_g->get_output()->addBCC($v2[0], $v2[1]);
		} else {
			if(sirius_tools_Utils::isValid($v2)) {
				$_g->get_output()->addBCC($v2, null);
			}
		}
	}
}
