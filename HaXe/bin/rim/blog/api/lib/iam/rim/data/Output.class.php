<?php

class iam_rim_data_Output {
	public function __construct(){}
	static $_stream;
	static $errors;
	static function get_errors() {
		if(!iam_rim_data_Output::$_stream->exists("errors")) {
			iam_rim_data_Output::$_stream->set("errors", sirius_Sirius::$gate->get_errors());
		}
		return iam_rim_data_Output::$_stream->get("errors");
	}
	static $result;
	static function get_result() {
		if(!iam_rim_data_Output::$_stream->exists("result")) {
			iam_rim_data_Output::$_stream->set("result", _hx_anonymous(array()));
		}
		return iam_rim_data_Output::$_stream->get("result");
	}
	static function write() {
		iam_rim_data_Output::get_result()->success = iam_rim_data_Output::get_errors()->length === 0;
		sirius_Sirius::$header->setJSON(iam_rim_data_Output::$_stream->get_data());
	}
	static $__properties__ = array("get_result" => "get_result","get_errors" => "get_errors");
	function __toString() { return 'iam.rim.data.Output'; }
}
iam_rim_data_Output::$_stream = new sirius_data_DataCache(null, null, null);
