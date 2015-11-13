<?php

class sirius_db_Clause {
	public function __construct($conditions, $joiner) {
		if(!php_Boot::$skip_constructor) {
		$this->_joiner = $joiner;
		$this->conditions = $conditions;
	}}
	public $_joiner;
	public $conditions;
	public function joiner() {
		return $this->_joiner;
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
	static function hOR($conditions) {
		return new sirius_db_Clause($conditions, " || ");
	}
	static function hAND($conditions) {
		return new sirius_db_Clause($conditions, " && ");
	}
	static function LIKE($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} LIKE :in_{{p}}", "value" => $value));
	}
	static function NOT_LIKE($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} NOT LIKE :in_{{p}}", "value" => $value));
	}
	static function EQUAL($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_{{p}}", "value" => $value));
	}
	static function NOT_EQUAL($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}!=:in_{{p}}", "value" => $value));
	}
	static function LESS($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}<:in_{{p}}", "value" => $value));
	}
	static function LESS_EQUAL($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}<=:in_{{p}}", "value" => $value));
	}
	static function GREATER($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}>:in_{{p}}", "value" => $value));
	}
	static function GREATER_EQUAL($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}>=:in_{{p}}", "value" => $value));
	}
	function __toString() { return 'sirius.db.Clause'; }
}
