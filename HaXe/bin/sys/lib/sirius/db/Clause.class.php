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
	static $_IDX = 0;
	static function hOR($conditions) {
		return new sirius_db_Clause($conditions, " || ");
	}
	static function hAND($conditions) {
		return new sirius_db_Clause($conditions, " && ");
	}
	static function LIKE($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} LIKE :in_" . Std::string(sirius_db_Clause_0($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function UNLIKE($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} NOT LIKE :in_" . Std::string(sirius_db_Clause_1($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function ID($value) {
		return _hx_anonymous(array("param" => "id", "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_2($value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function EQUAL($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_3($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function DIFFERENT($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}!=:in_" . Std::string(sirius_db_Clause_4($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function IN($param, $values) {
		$q = (new _hx_array(array()));
		sirius_utils_Dice::All($values, array(new _hx_lambda(array(&$param, &$q, &$values), "sirius_db_Clause_5"), 'execute'), null);
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} IN (" . _hx_string_or_null($q->join(",")) . ")", "value" => $values, "i" => sirius_db_Clause::$_IDX++));
	}
	static function REGEXP($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} REGEXP :in_" . Std::string(sirius_db_Clause_6($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function TRUE($param) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_7($param)), "value" => true, "i" => sirius_db_Clause::$_IDX++));
	}
	static function FALSE($param) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_8($param)), "value" => false, "i" => sirius_db_Clause::$_IDX++));
	}
	static function DIFF($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}!=:in_" . Std::string(sirius_db_Clause_9($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function LESS($param, $value, $or = null) {
		if($or === null) {
			$or = true;
		}
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}<" . _hx_string_or_null(((($or) ? "=" : ""))) . ":in_" . Std::string(sirius_db_Clause_10($or, $param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function GREATER($param, $value, $or = null) {
		if($or === null) {
			$or = true;
		}
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}>" . _hx_string_or_null(((($or) ? "=" : ""))) . ":in_" . Std::string(sirius_db_Clause_11($or, $param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function SPAN($param, $from, $to, $out = null) {
		if($out === null) {
			$out = false;
		}
		if($out) {
			return sirius_db_Clause::hOR((new _hx_array(array(sirius_db_Clause::LESS($param, $from, true), sirius_db_Clause::GREATER($param, $to, true)))));
		} else {
			return sirius_db_Clause::hAND((new _hx_array(array(sirius_db_Clause::GREATER($param, $from, true), sirius_db_Clause::LESS($param, $to, true)))));
		}
	}
	static function FLAGS($param, $flags, $any = null) {
		if($any === null) {
			$any = false;
		}
		$a = (new _hx_array(array()));
		sirius_utils_Dice::Values($flags, array(new _hx_lambda(array(&$a, &$any, &$flags, &$param), "sirius_db_Clause_12"), 'execute'), null);
		if($any) {
			return sirius_db_Clause::hOR($a);
		} else {
			return sirius_db_Clause::hAND($a);
		}
	}
	static function BIT($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} & :in_" . Std::string(sirius_db_Clause_13($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function BIT_NOT($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "~{{p}} & :in_" . Std::string(sirius_db_Clause_14($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	function __toString() { return 'sirius.db.Clause'; }
}
function sirius_db_Clause_0(&$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_1(&$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_2(&$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_3(&$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_4(&$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_5(&$param, &$q, &$values, $p, $v) {
	{
		$q[$q->length] = ":in_" . Std::string(sirius_db_Clause_15($p, $param, $q, $v, $values)) . "x" . _hx_string_or_null($p);
	}
}
function sirius_db_Clause_6(&$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_7(&$param) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_8(&$param) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_9(&$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_10(&$or, &$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_11(&$or, &$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_12(&$a, &$any, &$flags, &$param, $v) {
	{
		$a[$a->length] = sirius_db_Clause::BIT($param, $v);
	}
}
function sirius_db_Clause_13(&$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_14(&$param, &$value) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Clause_15(&$p, &$param, &$q, &$v, &$values) {
	{
		$int = sirius_db_Clause::$_IDX;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
