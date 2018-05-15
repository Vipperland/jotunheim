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
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} LIKE :in_" . Std::string(sirius_db_Clause_0($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function NOT_LIKE($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} NOT LIKE :in_" . Std::string(sirius_db_Clause_1($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function ID($value) {
		return _hx_anonymous(array("param" => "id", "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_2($value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function EQUAL($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_3($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function DIFFERENT($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}!=:in_" . Std::string(sirius_db_Clause_4($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function IS_NULL($param) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} :in_" . Std::string(sirius_db_Clause_5($param)) . "_", "value" => "\$IS NULL", "i" => sirius_db_Clause::$_IDX++));
	}
	static function NOT_NULL($param) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} != :in_" . Std::string(sirius_db_Clause_6($param)) . "_", "value" => "\$NULL", "i" => sirius_db_Clause::$_IDX++));
	}
	static function IN($param, $values) {
		if(Std::is($values, _hx_qtype("Array"))) {
			$q = (new _hx_array(array()));
			sirius_utils_Dice::All($values, array(new _hx_lambda(array(&$param, &$q, &$values), "sirius_db_Clause_7"), 'execute'), null);
			return _hx_anonymous(array("param" => $param, "condition" => "{{p}} IN (" . _hx_string_or_null($q->join(",")) . ")", "value" => $values, "i" => sirius_db_Clause::$_IDX++));
		} else {
			return _hx_anonymous(array("param" => $param, "condition" => "{{p}} IN (:in_" . Std::string(sirius_db_Clause_8($param, $values)) . ")", "value" => $values, "i" => sirius_db_Clause::$_IDX++));
		}
	}
	static function NOT_IN($param, $values) {
		if(Std::is($values, _hx_qtype("Array"))) {
			$q = (new _hx_array(array()));
			sirius_utils_Dice::All($values, array(new _hx_lambda(array(&$param, &$q, &$values), "sirius_db_Clause_9"), 'execute'), null);
			return _hx_anonymous(array("param" => $param, "condition" => "{{p}} NOT IN (" . _hx_string_or_null($q->join(",")) . ")", "value" => $values, "i" => sirius_db_Clause::$_IDX++));
		} else {
			return _hx_anonymous(array("param" => $param, "condition" => "{{p}} NOT IN (:in_" . Std::string(sirius_db_Clause_10($param, $values)) . ")", "value" => $values, "i" => sirius_db_Clause::$_IDX++));
		}
	}
	static function REGEXP($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} REGEXP :in_" . Std::string(sirius_db_Clause_11($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function TRUE($param) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_12($param)) . "_", "value" => true, "i" => sirius_db_Clause::$_IDX++));
	}
	static function FALSE($param) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_13($param)) . "_", "value" => false, "i" => sirius_db_Clause::$_IDX++));
	}
	static function DIFF($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}!=:in_" . Std::string(sirius_db_Clause_14($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function LESS($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}<:in_" . Std::string(sirius_db_Clause_15($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function LESS_OR($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}<=:in_" . Std::string(sirius_db_Clause_16($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function GREATER($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}>:in_" . Std::string(sirius_db_Clause_17($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function GREATER_OR($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}>=:in_" . Std::string(sirius_db_Clause_18($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function IN_RANGE($param, $from, $to) {
		return sirius_db_Clause::hAND((new _hx_array(array(sirius_db_Clause::GREATER($param, $from), sirius_db_Clause::LESS($param, $to)))));
	}
	static function OUT_RANGE($param, $from, $to) {
		return sirius_db_Clause::hOR((new _hx_array(array(sirius_db_Clause::LESS($param, $from), sirius_db_Clause::GREATER($param, $to)))));
	}
	static function FLAGS($param, $flags, $any = null) {
		if($any === null) {
			$any = false;
		}
		$a = (new _hx_array(array()));
		sirius_utils_Dice::Values($flags, array(new _hx_lambda(array(&$a, &$any, &$flags, &$param), "sirius_db_Clause_19"), 'execute'), null);
		if($any) {
			return sirius_db_Clause::hOR($a);
		} else {
			return sirius_db_Clause::hAND($a);
		}
	}
	static function BIT($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} & :in_" . Std::string(sirius_db_Clause_20($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function BIT_NOT($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "~{{p}} & :in_" . Std::string(sirius_db_Clause_21($param, $value)) . "_", "value" => $value, "i" => sirius_db_Clause::$_IDX++));
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
function sirius_db_Clause_5(&$param) {
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
function sirius_db_Clause_6(&$param) {
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
function sirius_db_Clause_7(&$param, &$q, &$values, $p, $v) {
	{
		$q[$q->length] = ":in_" . Std::string(sirius_db_Clause_22($p, $param, $q, $v, $values)) . "x" . _hx_string_or_null($p) . "_";
	}
}
function sirius_db_Clause_8(&$param, &$values) {
	{
		$int1 = sirius_db_Clause::$_IDX;
		if($int1 < 0) {
			return 4294967296.0 + $int1;
		} else {
			return $int1 + 0.0;
		}
		unset($int1);
	}
}
function sirius_db_Clause_9(&$param, &$q, &$values, $p, $v) {
	{
		$q[$q->length] = ":in_" . Std::string(sirius_db_Clause_23($p, $param, $q, $v, $values)) . "x" . _hx_string_or_null($p) . "_";
	}
}
function sirius_db_Clause_10(&$param, &$values) {
	{
		$int1 = sirius_db_Clause::$_IDX;
		if($int1 < 0) {
			return 4294967296.0 + $int1;
		} else {
			return $int1 + 0.0;
		}
		unset($int1);
	}
}
function sirius_db_Clause_11(&$param, &$value) {
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
function sirius_db_Clause_12(&$param) {
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
function sirius_db_Clause_13(&$param) {
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
function sirius_db_Clause_15(&$param, &$value) {
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
function sirius_db_Clause_16(&$param, &$value) {
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
function sirius_db_Clause_17(&$param, &$value) {
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
function sirius_db_Clause_18(&$param, &$value) {
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
function sirius_db_Clause_19(&$a, &$any, &$flags, &$param, $v) {
	{
		$a[$a->length] = sirius_db_Clause::BIT($param, $v);
	}
}
function sirius_db_Clause_20(&$param, &$value) {
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
function sirius_db_Clause_21(&$param, &$value) {
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
function sirius_db_Clause_22(&$p, &$param, &$q, &$v, &$values) {
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
function sirius_db_Clause_23(&$p, &$param, &$q, &$v, &$values) {
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
