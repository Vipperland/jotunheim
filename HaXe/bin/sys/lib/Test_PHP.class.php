<?php

class Test_PHP {
	public function __construct(){}
	static function main() {
		sirius_Sirius::$header->content(sirius_php_utils_Header::$JSON);
		$g = sirius_Sirius::$gate->open(new sirius_php_db_Token("localhost", 3306, "root", "", "apto.vc", null));
		if($g->isOpen()) {
			php_Lib::dump(_hx_array_get($g->fields((new _hx_array(array("types_states", "types_cities", "types_neighboorhoods"))))->get("types_states"), 0));
		}
	}
	function __toString() { return 'Test_PHP'; }
}
