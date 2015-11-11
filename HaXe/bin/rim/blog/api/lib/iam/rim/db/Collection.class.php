<?php

class iam_rim_db_Collection {
	public function __construct(){}
	static $_sessions;
	static $sessions;
	static function get_sessions() {
		if(iam_rim_db_Collection::$_sessions === null) {
			iam_rim_db_Collection::$_sessions = sirius_Sirius::$gate->getTable("sessions");
		}
		return iam_rim_db_Collection::$_sessions;
	}
	static $_users;
	static $users;
	static function get_users() {
		if(iam_rim_db_Collection::$_users === null) {
			iam_rim_db_Collection::$_users = sirius_Sirius::$gate->getTable("users");
		}
		return iam_rim_db_Collection::$_users;
	}
	static $__properties__ = array("get_users" => "get_users","get_sessions" => "get_sessions");
	function __toString() { return 'iam.rim.db.Collection'; }
}
