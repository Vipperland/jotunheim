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
			$commonLocale = _hx_anonymous(array("authentication" => "No authentication data specified", "sender" => "No sender data specified", "target" => "No target data specified", "subject" => "No default subject found", "missing" => "Param {{name}} value is null"));
			$locale = $d->get("locale");
			if($locale !== null) {
				sirius_utils_Dice::All($commonLocale, array(new _hx_lambda(array(&$commonLocale, &$d, &$e, &$locale, &$o, &$r, &$z), "sirius_php_ext_SendMail_0"), 'execute'), null);
			} else {
				$locale = $commonLocale;
			}
			$require = $d->get("require");
			if($require !== null && $require->length > 0) {
				sirius_utils_Dice::Values($require, array(new _hx_lambda(array(&$commonLocale, &$d, &$e, &$locale, &$o, &$r, &$require, &$z), "sirius_php_ext_SendMail_1"), 'execute'), null);
			}
			$x = sirius_Sirius::$domain->params->subject;
			if($x === null || strlen($x) === 0) {
				$x = $d->get("subject");
			}
			if($x === null || strlen($x) === 0) {
				sirius_php_ext_SendMail::_setError($e, "missing.param:subject", $locale->subject);
			}
			if($e->length === 0) {
				$o1 = $d->get("auth");
				$s = $d->get("sender");
				$to = $d->get("to");
				$cc = $d->get("cc");
				$bbc = $d->get("bcc");
				$ms = $d->get("message");
				if($o1 === null) {
					sirius_php_ext_SendMail::_setError($e, "missing.auth", $locale->authentication);
				}
				if($s === null) {
					sirius_php_ext_SendMail::_setError($e, "missing.sender", $locale->sender);
				}
				if($to === null || $to->length === 0) {
					sirius_php_ext_SendMail::_setError($e, "missing.to", $locale->target);
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
						sirius_utils_Dice::All(sirius_Sirius::$domain->params, array(new _hx_lambda(array(&$bbc, &$cc, &$commonLocale, &$d, &$e, &$locale, &$mail, &$ms, &$n, &$o, &$o1, &$r, &$require, &$s, &$to, &$ue, &$un, &$x, &$z), "sirius_php_ext_SendMail_2"), 'execute'), null);
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
			sirius_php_ext_SendMail::_setError($e, "missing.config", "Missing configuration file.");
		}
		sirius_Sirius::$header->setJSON();
		$o->set("result", $r);
		$o->json(true);
	}
	function __toString() { return 'sirius.php.ext.SendMail'; }
}
function sirius_php_ext_SendMail_0(&$commonLocale, &$d, &$e, &$locale, &$o, &$r, &$z, $p, $v) {
	{
		if(!_hx_has_field($locale, $p)) {
			$locale->{$p} = $v;
		}
	}
}
function sirius_php_ext_SendMail_1(&$commonLocale, &$d, &$e, &$locale, &$o, &$r, &$require, &$z, $v1) {
	{
		if(!sirius_Sirius::$domain->hrequire((new _hx_array(array($v1))))) {
			sirius_php_ext_SendMail::_setError($e, "missing.param:" . _hx_string_or_null($v1), sirius_utils_Filler::to($locale->missing, _hx_anonymous(array("name" => $v1)), null));
		}
	}
}
function sirius_php_ext_SendMail_2(&$bbc, &$cc, &$commonLocale, &$d, &$e, &$locale, &$mail, &$ms, &$n, &$o, &$o1, &$r, &$require, &$s, &$to, &$ue, &$un, &$x, &$z, $p1, $v2) {
	{
		$ms .= "<b>" . _hx_string_or_null($p1) . "</b>: " . Std::string($v2);
	}
}
