<?php

class sirius_db_Limit {
	public function __construct(){}
	static $ONE = "1";
	static function MAX($i = null) {
		if($i === null) {
			$i = 1;
		}
		return Std::string(sirius_db_Limit_0($i));
	}
	static function PAGE($i, $len = null) {
		if($len === null) {
			$len = 10;
		}
		return Std::string(sirius_db_Limit_1($i, $len)) . " offset " . Std::string(sirius_db_Limit_2($i, $len));
	}
	static function SECTION($from, $to) {
		$from = $from;
		$to = $to;
		return Std::string(sirius_db_Limit_3($from, $to)) . " offset " . Std::string(sirius_db_Limit_4($from, $to));
	}
	function __toString() { return 'sirius.db.Limit'; }
}
function sirius_db_Limit_0(&$i) {
	{
		$int = $i;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Limit_1(&$i, &$len) {
	{
		$int = $len;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Limit_2(&$i, &$len) {
	{
		$int1 = $i * $len;
		if($int1 < 0) {
			return 4294967296.0 + $int1;
		} else {
			return $int1 + 0.0;
		}
		unset($int1);
	}
}
function sirius_db_Limit_3(&$from, &$to) {
	{
		$int = $to - $from;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_db_Limit_4(&$from, &$to) {
	{
		$int1 = $from;
		if($int1 < 0) {
			return 4294967296.0 + $int1;
		} else {
			return $int1 + 0.0;
		}
		unset($int1);
	}
}
