<?php

class sirius_utils_Criptog {
	public function __construct(){}
	static function encodeBase64($q) {
		if(!Std::is($q, _hx_qtype("String"))) {
			$q = haxe_Json::phpJsonEncode($q, null, null);
		}
		return haxe_crypto_Base64::encode(haxe_io_Bytes::ofString($q), null);
	}
	static function decodeBase64($q, $json = null) {
		$r = null;
		try {
			$r = haxe_crypto_Base64::decode($q, null)->toString();
		}catch(Exception $__hx__e) {
			$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
			$e = $_ex_;
			{}
		}
		if($r !== null) {
			if($json && strlen($r) > 1) {
				return haxe_Json::phpJsonDecode($r);
			} else {
				return $r;
			}
		} else {
			return null;
		}
	}
	function __toString() { return 'sirius.utils.Criptog'; }
}
