<?php

class Test_PHP {
	public function __construct(){}
	static function main() {
		$g = sirius_Sirius::$gate->open(new sirius_php_db_Token("localhost", 3306, "root", "", "apto.vc", null));
		if($g->isOpen()) {
			$c = $g->prepare("SELECT id,name,abbreviation FROM types_states", null, null)->execute(null, null, null, null);
			if($c->success) {
				$c->queue("states");
				sirius_Sirius::$header->setJSON();
				sirius_Sirius::$cache->json(true, null);
			}
		} else {
			sirius_Sirius::log($g->errors, null, null);
		}
	}
	function __toString() { return 'Test_PHP'; }
}
