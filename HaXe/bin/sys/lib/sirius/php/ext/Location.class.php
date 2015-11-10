<?php

class sirius_php_ext_Location {
	public function __construct(){}
	static function main() {
		$GLOBALS['%s']->push("sirius.php.ext.Location::main");
		$__hx__spos = $GLOBALS['%s']->length;
		$gate = sirius_Sirius::$gate->open(new sirius_db_Token("localhost", 3306, "root", "", "apto.vc", null));
		$table = $gate->getTable("types_states");
		$table->restrict((new _hx_array(array("id", "name", "abbreviation"))));
		$data = $table->find(null, null, null);
		sirius_Sirius::$header->setJSON($data);
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.php.ext.Location'; }
}
