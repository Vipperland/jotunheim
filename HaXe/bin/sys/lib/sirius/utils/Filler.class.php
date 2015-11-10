<?php

class sirius_utils_Filler {
	public function __construct(){}
	static function _apply($path, $content, $data) {
		$GLOBALS['%s']->push("sirius.utils.Filler::_apply");
		$__hx__spos = $GLOBALS['%s']->length;
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
		{
			$GLOBALS['%s']->pop();
			return $content;
		}
		$GLOBALS['%s']->pop();
	}
	static function to($value, $data, $sufix = null) {
		$GLOBALS['%s']->push("sirius.utils.Filler::to");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = "";
		if(Std::is($data, _hx_qtype("Array"))) {
			sirius_utils_Dice::All($data, array(new _hx_lambda(array(&$data, &$r, &$sufix, &$value), "sirius_utils_Filler_1"), 'execute'), null);
		} else {
			$r = sirius_utils_Filler::_apply($sufix, $value, $data);
		}
		{
			$GLOBALS['%s']->pop();
			return $r;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.utils.Filler'; }
}
function sirius_utils_Filler_0(&$content, &$data, &$path, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.utils.Filler::_apply@18");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$content = sirius_utils_Filler::_apply(_hx_string_or_null($path) . _hx_string_or_null($p), $content, $v);
		$GLOBALS['%s']->pop();
	}
}
function sirius_utils_Filler_1(&$data, &$r, &$sufix, &$value, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.utils.Filler::to@36");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$v->{"%0"} = $p;
		$r .= _hx_string_or_null(sirius_utils_Filler::_apply($sufix, $value, $v));
		Reflect::deleteField($v, "%0");
		$GLOBALS['%s']->pop();
	}
}
