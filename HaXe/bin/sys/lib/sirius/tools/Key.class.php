<?php

class sirius_tools_Key {
	public function __construct(){}
	static function _cts() { $args = func_get_args(); return call_user_func_array(self::$_cts, $args); }
	static $_cts;
	static function COUNTER($id = null) {
		if($id === null) {
			$id = "global";
		}
		$v = 0;
		if(!_hx_has_field(sirius_tools_Key::$_cts, $id)) {
			sirius_tools_Key::$_cts->{$id} = 0;
		} else {
			$v = Reflect::field(sirius_tools_Key::$_cts, $id);
			sirius_tools_Key::$_cts->{$id} = $v + 1;
		}
		return $v;
	}
	static $TABLE = "abcdefghijklmnopqrstuvwxyz0123456789";
	static function GEN($size = null, $table = null, $mixCase = null) {
		if($mixCase === null) {
			$mixCase = true;
		}
		if($size === null) {
			$size = 9;
		}
		$s = "";
		if($table === null) {
			$table = sirius_tools_Key::$TABLE;
		}
		$l = strlen($table);
		$c = null;
		while(sirius_tools_Key_0($c, $l, $mixCase, $s, $size, $table)) {
			$c = _hx_substr($table, Std::random($l), 1);
			if($mixCase) {
				if(Math::random() < .5) {
					$c = strtoupper($c);
				} else {
					$c = strtolower($c);
				}
			}
			$s .= _hx_string_or_null($c);
		}
		return $s;
	}
	function __toString() { return 'sirius.tools.Key'; }
}
sirius_tools_Key::$_cts = _hx_anonymous(array("global" => 0));
function sirius_tools_Key_0(&$c, &$l, &$mixCase, &$s, &$size, &$table) {
	{
		$a = strlen($s);
		{
			$aNeg = $size < 0;
			$bNeg = $a < 0;
			if($aNeg !== $bNeg) {
				return $aNeg;
			} else {
				return $size > $a;
			}
			unset($bNeg,$aNeg);
		}
		unset($a);
	}
}
