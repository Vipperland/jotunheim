<?php

// Generated by Haxe 3.4.7
class sirius_gaming_dataform_DataIO {
	public function __construct(){}
	static function parse($c, $o, $nfo) {
		$obj = $c;
		sirius_utils_Dice::Values(_hx_explode("|", $o), array(new _hx_lambda(array(&$nfo, &$obj), "sirius_gaming_dataform_DataIO_0"), 'execute'), null);
		$obj->onUpdate();
		return $obj;
	}
	static function stringify($o, $n, $nfo) {
		$result = (new _hx_array(array()));
		$count = 0;
		sirius_utils_Dice::All($nfo, array(new _hx_lambda(array(&$count, &$o, &$result), "sirius_gaming_dataform_DataIO_1"), 'execute'), null);
		return _hx_string_or_null($n) . " " . _hx_string_or_null($result->join("|"));
	}
	function __toString() { return 'sirius.gaming.dataform.DataIO'; }
}
function sirius_gaming_dataform_DataIO_0(&$nfo, &$obj, $v) {
	{
		$tag = _hx_explode(":", $v);
		$par = $tag->shift();
		$par1 = Reflect::field($nfo, $par);
		{
			$value = _hx_explode("/_", $tag->join(":"))->join(" ");
			$obj->{$par1} = $value;
		}
	}
}
function sirius_gaming_dataform_DataIO_1(&$count, &$o, &$result, $p, $value) {
	{
		$value = Reflect::field($o, $value);
		if($value !== null) {
			if(Std::is($value, _hx_qtype("String"))) {
				$value = _hx_string_call($value, "split", array(" "))->join("/_");
			}
			$tmp = _hx_string_rec($p, "") . ":" . Std::string($value);
			$result[$count] = $tmp;
			$count = $count + 1;
		}
	}
}