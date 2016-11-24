<?php

class sirius_serial_IOTools {
	public function __construct(){}
	static function encodeBase64($q) {
		if(!Std::is($q, _hx_qtype("String"))) {
			$q = sirius_serial_IOTools::jsonEncode($q, null, null);
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
				return sirius_serial_IOTools::jsonDecode($r);
			} else {
				return $r;
			}
		} else {
			return null;
		}
	}
	static function jsonEncode($o, $rep = null, $space = null) {
		return sirius_serial_JsonTool::stringfy($o, $rep, $space);
	}
	static function jsonDecode($q) {
		return haxe_Json::phpJsonDecode($q);
	}
	static function md5Encode($o, $base64 = null) {
		if(Std::is($o, _hx_qtype("String"))) {
			return haxe_crypto_Md5::encode($o);
		} else {
			return haxe_crypto_Md5::encode((($base64) ? sirius_serial_IOTools::encodeBase64($o) : sirius_serial_IOTools::jsonEncode($o, null, null)));
		}
	}
	function __toString() { return 'sirius.serial.IOTools'; }
}
