<?php

class iam_rim_services_Users {
	public function __construct(){}
	static $ME;
	static $OTHER;
	static function init() {
		$_g = iam_rim_data_Input::$services->get(1);
		switch($_g) {
		case "login":{
			iam_rim_services_Users::doLogin();
		}break;
		case "logout":{
			iam_rim_services_Users::doLogout();
		}break;
		case "profile":{
			iam_rim_services_Users::getProfile();
		}break;
		default:{
			iam_rim_services_Users::renewSection();
		}break;
		}
	}
	static function getProfile() {
		$id = Std::parseInt(iam_rim_data_Input::$services->get(2));
		if($id !== null) {
			iam_rim_db_Collection::get_users()->restrict(iam_rim_services_Users::$OTHER);
			$clause = sirius_db_Clause::hAND((new _hx_array(array(sirius_db_Clause::EQUAL("id", $id), sirius_db_Clause::EQUAL("active", true)))));
			$entry = iam_rim_db_Collection::get_users()->findOne($clause);
			if($entry) {
				iam_rim_data_Output::get_result()->profile = _hx_deref(new iam_rim_data_User($entry))->data;
			}
		} else {
			iam_rim_data_Output::get_result()->user = null;
		}
	}
	static function doLogout() {
		$user = new iam_rim_data_User(null);
		if($user->checkSession(false)) {
			$all = iam_rim_data_Input::$services->get(2) === "all";
			$user->dropSession($all);
		}
	}
	static function doLogin() {
		$email = sirius_Sirius::$domain->params->email;
		$password = sirius_Sirius::$domain->params->password;
		if($email === null || $password === null) {
			if($email === null) {
				iam_rim_data_Output::get_errors()->push(new sirius_errors_Error(1001, "Form.Missing:EMAIL", null));
			}
			if($password === null) {
				iam_rim_data_Output::get_errors()->push(new sirius_errors_Error(1002, "Form.Missing:PASSWORD", null));
			}
		} else {
			iam_rim_db_Collection::get_users()->restrict(iam_rim_services_Users::$ME);
			$clause = sirius_db_Clause::hAND((new _hx_array(array(sirius_db_Clause::EQUAL("email", $email), sirius_db_Clause::EQUAL("password", haxe_crypto_Md5::encode($password))))));
			$entry = iam_rim_db_Collection::get_users()->findOne($clause);
			if($entry !== null) {
				$user = new iam_rim_data_User($entry);
				if(!$user->get_active() || $user->get_blocked()) {
					if(!$user->get_active()) {
						iam_rim_data_Output::get_errors()->push(new sirius_errors_Error(1003, "User.Activation:PENDING", null));
					}
					if($user->get_blocked()) {
						iam_rim_data_Output::get_errors()->push(new sirius_errors_Error(1004, "User.Activation:BANNED", null));
					}
				} else {
					iam_rim_data_Output::get_result()->user = $user->createSession()->data;
				}
			}
		}
	}
	static function renewSection() {
		_hx_deref(new iam_rim_data_User(null))->checkSession(true);
	}
	function __toString() { return 'iam.rim.services.Users'; }
}
iam_rim_services_Users::$ME = (new _hx_array(array("id", "name", "email", "created_at", "active", "blocked", "activity")));
iam_rim_services_Users::$OTHER = (new _hx_array(array("id", "name", "created_at", "blocked", "activity")));
