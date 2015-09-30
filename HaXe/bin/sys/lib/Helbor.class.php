<?php

class Helbor {
	public function __construct(){}
	static function main() {
		sirius_Sirius::$header->access("*", null, null, null);
		sirius_Sirius::$header->setJSON();
		$g = sirius_Sirius::$gate->open(new sirius_db_Token("localhost", 3306, "sitehelbor", "u4KCfPGEwMRmK2cZ", "sitehelbor", null));
		if($g->isOpen()) {
			$c = $g->prepare("SELECT * FROM basic_info WHERE extra LIKE \"%vtour%\" OR extra LIKE \"%TOUR%\"", null, null)->execute(null, null, null);
			if($c->success) {
				$data = new sirius_data_DataCache(null, null, null);
				$all = (new _hx_array(array()));
				sirius_utils_Dice::Values($c->result, array(new _hx_lambda(array(&$all, &$c, &$data, &$g), "Helbor_0"), 'execute'), null);
				$data->set("realty", $all);
				$data->json(true);
			}
		} else {
			sirius_Sirius::log($g->errors, null, null);
		}
	}
	function __toString() { return 'Helbor'; }
}
function Helbor_0(&$all, &$c, &$data, &$g, $v) {
	{
		$r = php_Lib::objectOfAssociativeArray($g->prepare("SELECT * FROM realty WHERE id=:id", _hx_anonymous(array("id" => $v->id)), null)->execute(null, null, null)->result[0]);
		$all[$all->length] = $r->url;
	}
}
