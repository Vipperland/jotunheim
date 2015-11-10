<?php

class Test_PHP {
	public function __construct(){}
	static function main() {
		$GLOBALS['%s']->push("Test_PHP::main");
		$__hx__spos = $GLOBALS['%s']->length;
		sirius_Sirius::$header->access("*", null, null, null);
		sirius_Sirius::$header->setJSON();
		$gate = new sirius_db_Gate();
		$gate1 = sirius_Sirius::$gate->open(new sirius_db_Token("localhost", 3306, "root", "", "apto.vc", null));
		$table = $gate1->getTable("types_states");
		$states = $table->find((new _hx_array(array("id", "name", "abbreviation"))), null, null, null);
		$data = new sirius_data_DataCache(null, null, null);
		$data->set("states", $states);
		$data->set("errors", $gate1->get_errors());
		$data->json(true);
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'Test_PHP'; }
}
