<?php

class haxe_Json {
	public function __construct(){}
	static function phpJsonDecode($json) {
		$val = json_decode($json);
		return haxe_Json::convertAfterDecode($val);
	}
	static function convertAfterDecode($val) {
		$arr = null;
		if(is_object($val)) {
			{
				$arr1 = php_Lib::associativeArrayOfObject($val);
				$arr = array_map((isset(haxe_Json::$convertAfterDecode) ? haxe_Json::$convertAfterDecode: array("haxe_Json", "convertAfterDecode")), $arr1);
			}
			return _hx_anonymous($arr);
		} else {
			if(is_array($val)) {
				{
					$arr2 = $val;
					$arr = array_map((isset(haxe_Json::$convertAfterDecode) ? haxe_Json::$convertAfterDecode: array("haxe_Json", "convertAfterDecode")), $arr2);
				}
				return new _hx_array($arr);
			} else {
				return $val;
			}
		}
	}
	function __toString() { return 'haxe.Json'; }
}
