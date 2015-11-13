<?php

class sirius_php_ext_Location {
	public function __construct(){}
	static function main() {
		$gate = sirius_Sirius::$gate->open(new sirius_db_Token("localhost", 3306, "root", "", "apto.vc", null));
		$table = $gate->table("types_states");
		$table->restrict((new _hx_array(array("id", "name", "abbreviation"))));
		$data = $table->findAll(null, null, null);
		sirius_Sirius::$header->setJSON($data);
	}
	function __toString() { return 'sirius.php.ext.Location'; }
}
