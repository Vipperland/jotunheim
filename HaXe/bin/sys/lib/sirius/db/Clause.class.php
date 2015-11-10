<?php

class sirius_db_Clause {
	public function __construct($conditions, $joiner) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.db.Clause::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_joiner = $joiner;
		$this->conditions = $conditions;
		$GLOBALS['%s']->pop();
	}}
	public $_joiner;
	public $conditions;
	public function joiner() {
		$GLOBALS['%s']->push("sirius.db.Clause::joiner");
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
		$GLOBALS['%s']->push("sirius.db.Clause::OR");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = new sirius_db_Clause($conditions, " || ");
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function hAND($conditions) {
		$GLOBALS['%s']->push("sirius.db.Clause::AND");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = new sirius_db_Clause($conditions, " && ");
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function LIKE($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clause::LIKE");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}} LIKE :in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function NOT_LIKE($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clause::NOT_LIKE");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}} NOT LIKE :in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function EQUAL($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clause::EQUAL");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function NOT_EQUAL($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clause::NOT_EQUAL");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}!=:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function LESS($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clause::LESS");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}<:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function LESS_EQUAL($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clause::LESS_EQUAL");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}<=:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function GREATER($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clause::GREATER");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}>:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	static function GREATER_EQUAL($param, $value) {
		$GLOBALS['%s']->push("sirius.db.Clause::GREATER_EQUAL");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_anonymous(array("param" => $param, "condition" => "{{p}}>=:in_{{p}}", "value" => $value));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.db.Clause'; }
}
