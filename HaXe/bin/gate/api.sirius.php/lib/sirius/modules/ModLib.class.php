<?php

class sirius_modules_ModLib {
	public function __construct(){}
	static function CACHE() { $args = func_get_args(); return call_user_func_array(self::$CACHE, $args); }
	static $CACHE;
	static function exists($module) {
		return _hx_has_field(sirius_modules_ModLib::$CACHE, $module);
	}
	static function register($file, $content) {
		$content = _hx_explode("[module:{", $content)->join("[!MOD!]");
		$content = _hx_explode("[Module:{", $content)->join("[!MOD!]");
		$sur = _hx_explode("[!MOD!]", $content);
		if($sur->length > 1) {
			sirius_utils_Dice::All($sur, array(new _hx_lambda(array(&$content, &$file, &$sur), "sirius_modules_ModLib_0"), 'execute'), null);
		} else {
			sirius_modules_ModLib::$CACHE->{$file} = $content;
		}
	}
	static function get($name, $data = null) {
		if(!sirius_modules_ModLib::exists($name)) {
			return "<span style='color:#ff0000;font-weight:bold;'>Undefined Module::" . _hx_string_or_null($name) . "</span><br/>";
		}
		$content = Reflect::field(sirius_modules_ModLib::$CACHE, $name);
		if($data !== null) {
			return sirius_utils_Filler::to($content, $data, null);
		} else {
			return $content;
		}
	}
	static function fill($module, $data, $sufix = null) {
		return sirius_utils_Filler::to(sirius_modules_ModLib::get($module, null), $data, $sufix);
	}
	static function prepare($file) {
		if($file !== null && file_exists($file)) {
			sirius_modules_ModLib::register($file, sys_io_File::getContent($file));
			return true;
		}
		return false;
	}
	static function hprint($name, $data = null, $repeat = null, $sufix = null) {
		if($repeat) {
			$module = sirius_modules_ModLib::get($name, null);
			sirius_utils_Dice::Values($data, array(new _hx_lambda(array(&$data, &$module, &$name, &$repeat, &$sufix), "sirius_modules_ModLib_1"), 'execute'), null);
		} else {
			php_Lib::hprint(sirius_modules_ModLib::get($name, $data));
		}
	}
	function __toString() { return 'sirius.modules.ModLib'; }
}
sirius_modules_ModLib::$CACHE = _hx_anonymous(array());
function sirius_modules_ModLib_0(&$content, &$file, &$sur, $p, $v) {
	{
		if($p > 0) {
			$i = _hx_index_of($v, "}]", null);
			if($i !== -1) {
				$mod = null;
				{
					$text = "{" . _hx_string_or_null(_hx_substr($v, 0, $i)) . "}";
					$mod = haxe_Json::phpJsonDecode($text);
				}
				if($mod->name === null) {
					$mod->name = $file;
				}
				sirius_php_Sirius::log("Building Module [" . _hx_string_or_null($mod->name) . "]", 10, 1);
				$end = _hx_index_of($v, ";;;", null);
				$content = _hx_substring($v, $i + 2, sirius_modules_ModLib_2($content, $end, $file, $i, $mod, $p, $sur, $v));
				if($mod->{"require"} !== null) {
					$dependencies = _hx_explode(";", $mod->{"require"});
					sirius_php_Sirius::log("\x09Validating dependencies...", 10, 1);
					sirius_utils_Dice::Values($dependencies, array(new _hx_lambda(array(&$content, &$dependencies, &$end, &$file, &$i, &$mod, &$p, &$sur, &$v), "sirius_modules_ModLib_3"), 'execute'), null);
				}
				sirius_modules_ModLib::$CACHE->{$mod->name} = $content;
			} else {
				sirius_php_Sirius::log("\x09(" . _hx_string_or_null(_hx_substr($v, 0, 15)) . "...) Missing or Invalid MODULE tag in [" . _hx_string_or_null($file) . "]", 10, 3);
			}
		}
	}
}
function sirius_modules_ModLib_1(&$data, &$module, &$name, &$repeat, &$sufix, $v) {
	{
		php_Lib::hprint(sirius_utils_Filler::to($module, $v, $sufix));
	}
}
function sirius_modules_ModLib_2(&$content, &$end, &$file, &$i, &$mod, &$p, &$sur, &$v) {
	if($end === -1) {
		return strlen($v);
	} else {
		return $end;
	}
}
function sirius_modules_ModLib_3(&$content, &$dependencies, &$end, &$file, &$i, &$mod, &$p, &$sur, &$v, $v1) {
	{
		$set = Reflect::field(sirius_modules_ModLib::$CACHE, $v1);
		if($set === null) {
			sirius_php_Sirius::log("MODULE(" . _hx_string_or_null($v1) . ") : MISSING", 10, 2);
		} else {
			sirius_php_Sirius::log("\x09\x09[" . _hx_string_or_null($v1) . "] OK!", 10, 1);
			$content = _hx_explode("<import " . _hx_string_or_null($v1) . "/>", $content)->join($set);
		}
	}
}
