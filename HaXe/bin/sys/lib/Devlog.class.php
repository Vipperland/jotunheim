<?php

class Devlog extends sirius_db_objects_TableObject {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct(sirius_Sirius::$gate->table("devlog"),null);
	}}
	static $__properties__ = array("get_id" => "get_id");
	function __toString() { return 'Devlog'; }
}
