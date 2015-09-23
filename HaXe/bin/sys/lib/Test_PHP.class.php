<?php

class Test_PHP {
	public function __construct(){}
	static function main() {
		sirius_Sirius::$header->access("*", null, null, null);
		sirius_Sirius::$header->setJSON();
		$data = new sirius_data_DataCache("test", "domain", 1000);
		if($data->load()->exists(null)) {
			$data->json(true);
			return;
		}
		$g = sirius_Sirius::$gate->open(new sirius_db_Token("localhost", 3306, "root", "", "apto.vc", null));
		if($g->isOpen()) {
			$c = $g->prepare("SELECT id,name,abbreviation FROM types_states", null, null)->execute(null, null, null);
			if($c->success) {
				$data->set("states", $c->result);
				$data->json(true);
				$data->save();
			}
		} else {
			sirius_Sirius::log($g->errors, null, null);
		}
	}
	function __toString() { return 'Test_PHP'; }
}
