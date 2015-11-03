<?php

class sirius_php_ext_SendMail {
	public function __construct(){}
	static function _setError($e, $error, $message) {
		$e[$e->length] = _hx_anonymous(array("error" => $error, "message" => $message));
	}
	static function main() {
		$e = (new _hx_array(array()));
		$z = null;
		$r = _hx_anonymous(array("errors" => $e));
		$d = new sirius_data_DataCache("mail", "conf", 0);
		$o = new sirius_data_DataCache(null, null, null);
		if($d->load(true)) {
			$require = $d->get("require");
			if($require !== null && $require->length > 0) {
				sirius_utils_Dice::Values($require, array(new _hx_lambda(array(&$d, &$e, &$o, &$r, &$require, &$z), "sirius_php_ext_SendMail_0"), 'execute'), null);
			}
			$x = sirius_Sirius::$domain->params->subject;
			if($x === null || strlen($x) === 0) {
				$x = $d->get("subject");
			}
			if($x === null || strlen($x) === 0) {
				sirius_php_ext_SendMail::_setError($e, "missing.subject", "No default subject found");
			}
			if($e->length === 0) {
				$o1 = $d->get("auth");
				$s = $d->get("sender");
				$to = $d->get("to");
				$cc = $d->get("cc");
				$bbc = $d->get("bcc");
				$ms = $d->get("message");
				if($o1 === null) {
					sirius_php_ext_SendMail::_setError($e, "missing.auth", "No authentication data specified");
				}
				if($s === null) {
					sirius_php_ext_SendMail::_setError($e, "missing.sender", "No sender data specified");
				}
				if($to === null || $to->length === 0) {
					sirius_php_ext_SendMail::_setError($e, "missing.to", "No target data specified");
				}
				if($e->length === 0) {
					$mail = new sirius_php_net_Mailer($o1->host, $o1->user, $o1->password, $o1->secure, $o1->port);
					$mail->origin($s->name, $s->email);
					$mail->targets($to, $cc, $bbc);
					$n = $d->get("origin");
					$un = null;
					if(_hx_field($n, "name") !== null) {
						$un = Reflect::field(sirius_Sirius::$domain->params, $n->name);
					} else {
						$un = null;
					}
					$ue = null;
					if(_hx_field($n, "email") !== null) {
						$ue = Reflect::field(sirius_Sirius::$domain->params, $n->email);
					} else {
						$ue = null;
					}
					if($ue !== null) {
						if($un !== null) {
							$mail->get_output()->addReplyTo($ue, $un);
						} else {
							$mail->get_output()->addReplyTo($ue, null);
						}
					}
					if($ms === null) {
						$ms = "";
						sirius_utils_Dice::All(sirius_Sirius::$domain->params, array(new _hx_lambda(array(&$bbc, &$cc, &$d, &$e, &$mail, &$ms, &$n, &$o, &$o1, &$r, &$require, &$s, &$to, &$ue, &$un, &$x, &$z), "sirius_php_ext_SendMail_1"), 'execute'), null);
					} else {
						$ms = sirius_utils_Filler::to($ms, sirius_Sirius::$domain->params, null);
					}
					$mail->message($x, $ms);
					$r->success = $mail->send();
					if(!$r->success) {
						sirius_php_ext_SendMail::_setError($e, "phpmailer.error", $mail->getError());
					}
					$log = $d->get("log");
					if($log) {
						$u = new sirius_data_DataCache("" . _hx_string_rec(Date::now()->getTime(), ""), "conf/mail_log", 0);
						$u->set("recipients", sirius_utils_Dice::Mix((new _hx_array(array($to, $cc, $bbc)))));
						$u->set("mail", _hx_anonymous(array("subject" => $x, "message" => $ms)));
						$u->set("result", $r);
						$u->save(true);
					}
				}
			}
		} else {
			sirius_Sirius::$header->setJSON();
			sirius_php_ext_SendMail::_setError($e, "missing.config", "Missing configuration file.");
		}
		$o->set("result", $r);
		$o->json(true);
	}
	function __toString() { return 'sirius.php.ext.SendMail'; }
}
function sirius_php_ext_SendMail_0(&$d, &$e, &$o, &$r, &$require, &$z, $v) {
	{
		if(!sirius_Sirius::$domain->hrequire((new _hx_array(array($v))))) {
			sirius_php_ext_SendMail::_setError($e, "missing.param:" . _hx_string_or_null($v), "Param " . _hx_string_or_null($v) . " value is null");
		}
	}
}
function sirius_php_ext_SendMail_1(&$bbc, &$cc, &$d, &$e, &$mail, &$ms, &$n, &$o, &$o1, &$r, &$require, &$s, &$to, &$ue, &$un, &$x, &$z, $p, $v1) {
	{
		$ms .= "<b>" . _hx_string_or_null($p) . "</b>: " . Std::string($v1);
	}
}
