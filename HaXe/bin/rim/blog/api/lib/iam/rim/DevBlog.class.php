<?php

class iam_rim_DevBlog {
	public function __construct(){}
	static $data;
	static function main() {
		sirius_Sirius::$gate->open(sirius_db_Token::to("localhost", 3306, "root", "", "iamrimblog", null));
		{
			$_g = strtolower(iam_rim_data_Input::get_head());
			switch($_g) {
			case "user":{
				iam_rim_services_Users::init();
			}break;
			case "post":{
				iam_rim_services_Posts::init();
			}break;
			}
		}
		iam_rim_data_Output::write();
	}
	function __toString() { return 'iam.rim.DevBlog'; }
}
iam_rim_DevBlog::$data = new sirius_data_DataCache(null, null, null);
