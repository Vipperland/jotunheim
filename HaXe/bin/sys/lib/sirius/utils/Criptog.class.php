<?php

class sirius_utils_Criptog {
	public function __construct(){}
	static function encodeBase64($q) {
		$GLOBALS['%s']->push("sirius.utils.Criptog::encodeBase64");
		$__hx__spos = $GLOBALS['%s']->length;
		if(!Std::is($q, _hx_qtype("String"))) {
			$q = haxe_Json::phpJsonEncode($q, null, null);
		}
		{
			$tmp = haxe_crypto_Base64::encode(haxe_io_Bytes::ofString($q), null);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function decodeBase64($q, $json = null) {
		$GLOBALS['%s']->push("sirius.utils.Criptog::decodeBase64");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = null;
		try {
			$r = haxe_crypto_Base64::decode($q, null)->toString();
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			$e = $_ex_;
			{
				$GLOBALS['%e'] = (new _hx_array(array()));
				while($GLOBALS['%s']->length >= $__hx__spos) {
					$GLOBALS['%e']->unshift($GLOBALS['%s']->pop());
				}
				$GLOBALS['%s']->push($GLOBALS['%e'][0]);
			}
		}
		if($r !== null) {
			if($json && strlen($r) > 1) {
				$tmp = haxe_Json::phpJsonDecode($r);
				$GLOBALS['%s']->pop();
				return $tmp;
			} else {
				$GLOBALS['%s']->pop();
				return $r;
			}
		} else {
			$GLOBALS['%s']->pop();
			return null;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.utils.Criptog'; }
}
