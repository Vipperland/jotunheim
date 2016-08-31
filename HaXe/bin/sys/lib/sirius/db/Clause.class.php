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
	static function REGEXP($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} REGEXP :in_" . Std::string(sirius_db_Clause_4($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function TRUE($param) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_5($param)), "value" => true, "i" => sirius_db_Clause::$_IDX++));
	}
	static function FALSE($param) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}=:in_" . Std::string(sirius_db_Clause_6($param)), "value" => false, "i" => sirius_db_Clause::$_IDX++));
	}
	static function UNEQUAL($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}!=:in_" . Std::string(sirius_db_Clause_7($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function LESS($param, $value, $or = null) {
		if($or === null) {
			$or = true;
		}
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}<" . _hx_string_or_null(((($or) ? "=" : ""))) . ":in_" . Std::string(sirius_db_Clause_8($or, $param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function GREATER($param, $value, $or = null) {
		if($or === null) {
			$or = true;
		}
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}}>" . _hx_string_or_null(((($or) ? "=" : ""))) . ":in_" . Std::string(sirius_db_Clause_9($or, $param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function BIT($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "{{p}} & :in_" . Std::string(sirius_db_Clause_10($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
	}
	static function BIT_NOT($param, $value) {
		return _hx_anonymous(array("param" => $param, "condition" => "~{{p}} & :in_" . Std::string(sirius_db_Clause_11($param, $value)), "value" => $value, "i" => sirius_db_Clause::$_IDX++));
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
function sirius_db_Clause_7(&$param, &$value) {
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
function sirius_db_Clause_8(&$or, &$param, &$value) {
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
function sirius_db_Clause_9(&$or, &$param, &$value) {
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
function sirius_db_Clause_10(&$param, &$value) {
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
