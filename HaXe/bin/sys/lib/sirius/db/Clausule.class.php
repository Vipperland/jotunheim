<?php

class sirius_db_Clausule {
	public function __construct($conditions, $joiner) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.db.Clausule::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_joiner = $joiner;
		$this->conditions = $conditions;
		$GLOBALS['%s']->pop();
	}}
	public $_joiner;
	public $conditions;
	public function joiner() {
		$GLOBALS['%s']->push("sirius.db.Clausule::joiner");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_joiner;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
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
		$GLOBALS['%s']->push("sirius.db.Clausule::OR");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = new sirius_db_Clausule($conditions, " || ");
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function hAND($conditions) {
		$GLOBALS['%s']->push("sirius.db.Clausule::AND");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = new sirius_db_Clausule($conditions, " && ");
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function LIKE($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clausule::LIKE");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}} LIKE :in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function NOT_LIKE($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clausule::NOT_LIKE");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}} NOT LIKE :in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function EQUAL($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clausule::EQUAL");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function NOT_EQUAL($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clausule::NOT_EQUAL");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}!=:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function LESS($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clausule::LESS");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}<:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function LESS_EQUAL($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clausule::LESS_EQUAL");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}<=:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function GREATER($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clausule::GREATER");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}>:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function GREATER_EQUAL($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clausule::GREATER_EQUAL");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}>=:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.db.Clausule'; }
}
