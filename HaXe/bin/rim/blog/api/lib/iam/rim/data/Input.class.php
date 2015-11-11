<?php

class iam_rim_data_Input {
	public function __construct(){}
	static $services;
	static $head;
	static function get_head() {
		if(iam_rim_data_Input::$services === null) {
			iam_rim_data_Input::$services = new sirius_data_Fragments(sirius_Sirius::$domain->params->service, "/");
		}
		return iam_rim_data_Input::$services->first;
	}
	static $__properties__ = array("get_head" => "get_head");
	function __toString() { return 'iam.rim.data.Input'; }
}
