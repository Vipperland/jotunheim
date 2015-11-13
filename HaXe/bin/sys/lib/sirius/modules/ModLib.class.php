<?php

class sirius_modules_ModLib {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->_predata = (new _hx_array(array()));
	}}
	public $_predata;
	public function _sanitize($name, $data) {
		sirius_utils_Dice::Values($this->_predata, array(new _hx_lambda(array(&$data, &$name), "sirius_modules_ModLib_0"), 'execute'), null);
		return $data;
	}
	public function onModuleRequest($handler) {
		if(Lambda::indexOf($this->_predata, $handler) === -1) {
			$this->_predata[$this->_predata->length] = $handler;
		}
	}
	public function exists($module) {
		return _hx_has_field(sirius_modules_ModLib::$CACHE, $module);
	}
	public function register($file, $content) {
		$_g = $this;
		$content = _hx_explode("[module:{", $content)->join("[!MOD!]");
		$content = _hx_explode("[Module:{", $content)->join("[!MOD!]");
		$sur = _hx_explode("[!MOD!]", $content);
		if($sur->length > 1) {
			sirius_Sirius::log("ModLib => PARSING " . _hx_string_or_null($file), 1);
			sirius_utils_Dice::All($sur, array(new _hx_lambda(array(&$_g, &$content, &$file, &$sur), "sirius_modules_ModLib_1"), 'execute'), null);
		} else {
			$field1 = strtolower($file);
			sirius_modules_ModLib::$CACHE->{$field1} = $content;
		}
	}
	public function get($name, $data = null) {
		$name = strtolower($name);
		if(!$this->exists($name)) {
			return "<span style='color:#ff0000;font-weight:bold;'>Undefined [Module:" . _hx_string_or_null($name) . "]</span><br/>";
		}
		$content = Reflect::field(sirius_modules_ModLib::$CACHE, $name);
		$data = $this->_sanitize($name, $data);
		if($data !== null) {
			return sirius_utils_Filler::to($content, $data, null);
		} else {
			return $content;
		}
	}
	public function fill($module, $data, $sufix = null) {
		return sirius_utils_Filler::to($this->get($module, null), $data, $sufix);
	}
	public function prepare($file) {
		if($file !== null && file_exists($file)) {
			$this->register($file, sys_io_File::getContent($file));
			return true;
		}
		return false;
	}
	public function hprint($name, $data = null, $repeat = null, $sufix = null) {
		if($repeat) {
			$module = $this->get($name, null);
			sirius_utils_Dice::Values($data, array(new _hx_lambda(array(&$data, &$module, &$name, &$repeat, &$sufix), "sirius_modules_ModLib_2"), 'execute'), null);
		} else {
			php_Lib::hprint($this->get($name, $data));
		}
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
	static function CACHE() { $args = func_get_args(); return call_user_func_array(self::$CACHE, $args); }
	static $CACHE;
	function __toString() { return 'sirius.modules.ModLib'; }
}
sirius_modules_ModLib::$CACHE = _hx_anonymous(array());
function sirius_modules_ModLib_0(&$data, &$name, $v) {
	{
		$data = call_user_func_array($v, array($name, $data));
	}
}
function sirius_modules_ModLib_1(&$_g, &$content, &$file, &$sur, $p, $v) {
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
				} else {
					sirius_Sirius::log("\x09\x09ModLib => NAME " . _hx_string_or_null($mod->name), 1);
				}
				if($_g->exists($mod->name)) {
					sirius_Sirius::log("\x09ModLib => OVERRIDE " . _hx_string_or_null($mod->name), 2);
				}
				$end = _hx_index_of($v, "/EOF;", null);
				$content = _hx_substring($v, $i + 2, sirius_modules_ModLib_3($_g, $content, $end, $file, $i, $mod, $p, $sur, $v));
				if($mod->type === "null" || $mod->type === "html") {
					$content = _hx_explode("\x0A", _hx_explode("\x0D", $content)->join(""))->join("");
				}
				if($mod->{"require"} !== null) {
					$dependencies = _hx_explode(";", $mod->{"require"});
					sirius_Sirius::log("\x09ModLib => " . _hx_string_or_null($mod->name) . " VERIFYING...", 1);
					sirius_utils_Dice::Values($dependencies, array(new _hx_lambda(array(&$_g, &$content, &$dependencies, &$end, &$file, &$i, &$mod, &$p, &$sur, &$v), "sirius_modules_ModLib_4"), 'execute'), null);
				}
				{
					$field = strtolower($mod->name);
					sirius_modules_ModLib::$CACHE->{$field} = $content;
				}
			} else {
				Std::string(sirius_Sirius::log("\x09ModLib => CONFIG ERROR " . _hx_string_or_null($file) . "(" . _hx_string_or_null(_hx_substr($v, 0, 15)), 3)) . "...)";
			}
		}
	}
}
function sirius_modules_ModLib_2(&$data, &$module, &$name, &$repeat, &$sufix, $v) {
	{
		php_Lib::hprint(sirius_utils_Filler::to($module, $v, $sufix));
	}
}
function sirius_modules_ModLib_3(&$_g, &$content, &$end, &$file, &$i, &$mod, &$p, &$sur, &$v) {
	if($end === -1) {
		return strlen($v);
	} else {
		return $end;
	}
}
function sirius_modules_ModLib_4(&$_g, &$content, &$dependencies, &$end, &$file, &$i, &$mod, &$p, &$sur, &$v, $v1) {
	{
		$set = Reflect::field(sirius_modules_ModLib::$CACHE, strtolower($v1));
		if($set === null) {
			sirius_Sirius::log("\x09\x09ModLib => REQUIRED " . _hx_string_or_null($v1), 2);
		} else {
			$content = _hx_explode("<import " . _hx_string_or_null($v1) . "/>", $content)->join($set);
		}
	}
}
