<?php

class sirius_tools_Key {
	public function __construct(){}
	static $_counter = 0;
	static function COUNTER() {
		return sirius_tools_Key::$_counter++;
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
