<?php

class sirius_utils_Filler {
	public function __construct(){}
	static function _apply($path, $content, $data) {
		if($data === null) {
			$content = _hx_explode("{{" . _hx_string_or_null($path) . "}}", $content)->join("");
		} else {
			if(Std::is($data, _hx_qtype("Float")) || Std::is($data, _hx_qtype("String")) || Std::is($data, _hx_qtype("Bool")) || Std::is($data, _hx_qtype("Int"))) {
				$content = _hx_explode("{{" . _hx_string_or_null($path) . "}}", $content)->join($data);
			} else {
				if($path !== null && $path !== "") {
					$path = _hx_string_or_null($path) . ".";
				} else {
					$path = "";
				}
				sirius_utils_Dice::All($data, array(new _hx_lambda(array(&$content, &$data, &$path), "sirius_utils_Filler_0"), 'execute'), null);
			}
		}
		return $content;
	}
	static function to($value, $data, $sufix = null) {
		$r = "";
		if(Std::is($data, _hx_qtype("Array"))) {
			sirius_utils_Dice::All($data, array(new _hx_lambda(array(&$data, &$r, &$sufix, &$value), "sirius_utils_Filler_1"), 'execute'), null);
		} else {
			$r = sirius_utils_Filler::_apply($sufix, $value, $data);
		}
		return $r;
	}
	static function extractNumber($value) {
		$s = "";
		$i = 0;
		while(sirius_utils_Filler_2($i, $s, $value)) {
			$j = Std::parseInt(_hx_substr($value, $i, 1));
			++$i;
			if($j !== null) {
				$s .= Std::string(sirius_utils_Filler_3($i, $j, $s, $value)) . "";
			}
			unset($j);
		}
		$i = Std::parseInt($s);
		if($i === null) {
			return 0;
		} else {
			return $i;
		}
	}
	function __toString() { return 'sirius.utils.Filler'; }
}
function sirius_utils_Filler_0(&$content, &$data, &$path, $p, $v) {
	{
		$content = sirius_utils_Filler::_apply(_hx_string_or_null($path) . _hx_string_or_null($p), $content, $v);
	}
}
function sirius_utils_Filler_1(&$data, &$r, &$sufix, &$value, $p, $v) {
	{
		$v->{"%0"} = $p;
		$r .= _hx_string_or_null(sirius_utils_Filler::_apply($sufix, $value, $v));
		Reflect::deleteField($v, "%0");
	}
}
function sirius_utils_Filler_2(&$i, &$s, &$value) {
	{
		$b = strlen($value);
		{
			$aNeg = $b < 0;
			$bNeg = $i < 0;
			if($aNeg !== $bNeg) {
				return $aNeg;
			} else {
				return $b > $i;
			}
			unset($bNeg,$aNeg);
		}
		unset($b);
	}
}
function sirius_utils_Filler_3(&$i, &$j, &$s, &$value) {
	{
		$int = $j;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
