<?php

class MainPHP {
	public function __construct(){}
	static function main() {
		sirius_php_Sirius::$header->content(sirius_php_utils_Header::$JSON);
		$g = sirius_php_Sirius::$db->open(new php_db_Token("localhost", 3306, "root", "", "apto.vc", null));
		if($g->isOpen()) {
			$c = $g->prepare("SELECT * FROM types_states", null, null)->execute(null, null, null, null);
			if($c->success) {
				$c->queue("states");
				sirius_php_Sirius::$header->setJSON();
				sirius_php_Sirius::$cache->json(true, (isset(haxe_Utf8::$encode) ? haxe_Utf8::$encode: array("haxe_Utf8", "encode")));
				sirius_php_Sirius::$cache->json(true, (isset(haxe_Utf8::$decode) ? haxe_Utf8::$decode: array("haxe_Utf8", "decode")));
			}
		}
	}
	function __toString() { return 'MainPHP'; }
}
