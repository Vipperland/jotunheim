<?php

class Test_PHP {
	public function __construct(){}
	static function main() {
		sirius_Sirius::$header->content(sirius_php_utils_Header::$JSON);
		$g = sirius_Sirius::$database->open(new php_db_Token("localhost", 3306, "root", "", "apto.vc", null));
		if($g->isOpen()) {
			$c = $g->prepare("SELECT id,name,abbreviation FROM types_states", null, null)->execute(null, null, null, null);
			if($c->success) {
				$c->queue("states");
				sirius_Sirius::$header->setJSON();
				sirius_Sirius::$cache->json(true, null);
			}
		}
	}
	function __toString() { return 'Test_PHP'; }
}
