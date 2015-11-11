<?php

class iam_rim_data_User {
	public function __construct($data) {
		if(!php_Boot::$skip_constructor) {
		$this->data = $data;
		$this->token = sirius_Sirius::$domain->params->token;
	}}
	public $data;
	public $id;
	public function get_id() {
		return $this->data->id;
	}
	public $name;
	public function get_name() {
		return $this->data->name;
	}
	public $email;
	public function get_email() {
		return $this->data->email;
	}
	public $active;
	public function get_active() {
		return $this->data->active;
	}
	public $blocked;
	public function get_blocked() {
		return $this->data->blocked;
	}
	public $createdAt;
	public function get_createdAt() {
		return $this->data->created_at;
	}
	public $activity;
	public function get_activity() {
		return $this->data->activity;
	}
	public $token;
	public function createSession() {
		if($this->token === null && $this->get_email() !== null) {
			$ip = sirius_Sirius::$domain->data->REMOTE_ADDR;
			$this->token = haxe_crypto_Md5::encode(_hx_string_or_null($this->get_email()) . ":" . _hx_string_or_null($ip));
			$delClause = sirius_db_Clause::hAND((new _hx_array(array(sirius_db_Clause::EQUAL("ip", $ip), sirius_db_Clause::EQUAL("user_id", $this->get_id())))));
			iam_rim_db_Collection::get_sessions()->delete($delClause, null, null);
			iam_rim_db_Collection::get_sessions()->create(_hx_anonymous(array("user_id" => $this->get_id(), "token" => $this->token, "ip" => $ip)), null, null, null);
			return $this;
		} else {
			return null;
		}
	}
	public function checkSession($update) {
		$current = null;
		if($this->hasToken()) {
			$time = Date::now();
			$now = $time->toString();
			$upClause = sirius_db_Clause::hAND((new _hx_array(array(sirius_db_Clause::EQUAL("ip", sirius_Sirius::$domain->data->REMOTE_ADDR), sirius_db_Clause::EQUAL("token", $this->token)))));
			$current = iam_rim_db_Collection::get_sessions()->findOne($upClause);
			if($current !== null) {
				$lastUp = Date::fromString($current->updated_at)->getTime();
				$age = $lastUp - $time->getTime();
				if($age > 1296000) {
					iam_rim_db_Collection::get_sessions()->delete($upClause, null, null);
					iam_rim_data_Output::get_result()->session = _hx_anonymous(array("updated" => $now, "expired" => true, "valid" => false));
				} else {
					$this->id = $current->user_id;
					if($update) {
						iam_rim_db_Collection::get_sessions()->update(_hx_anonymous(array("updated_at" => $now)), $upClause, null, sirius_db_Limit::MAX(1));
					}
					iam_rim_data_Output::get_result()->session = _hx_anonymous(array("updated" => $now, "expired" => false, "valid" => true));
				}
			} else {
				iam_rim_data_Output::get_result()->session = null;
			}
		}
		return $current !== null;
	}
	public function hasToken() {
		return $this->token !== null;
	}
	public function dropSession($all) {
		iam_rim_db_Collection::get_sessions()->delete((($all) ? sirius_db_Clause::EQUAL("user_id", $this->get_id()) : sirius_db_Clause::EQUAL("token", $this->token)), null, (($all) ? null : sirius_db_Limit::MAX(1)));
		iam_rim_data_Output::get_result()->session = null;
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	static $__properties__ = array("get_activity" => "get_activity","get_createdAt" => "get_createdAt","get_blocked" => "get_blocked","get_active" => "get_active","get_email" => "get_email","get_name" => "get_name","get_id" => "get_id");
	function __toString() { return 'iam.rim.data.User'; }
}
