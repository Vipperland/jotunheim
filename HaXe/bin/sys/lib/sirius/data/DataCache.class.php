<?php

class sirius_data_DataCache implements sirius_data_IDataCache{
	public function __construct($name = null, $path = null, $expire = null) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.data.DataCache::new");
		$__hx__spos = $GLOBALS['%s']->length;
		if($expire === null) {
			$expire = 0;
		}
		$this->_validated = false;
		$this->_name = $name;
		$this->_path = $path;
		$this->_expire = $expire;
		$this->clear(null);
		$GLOBALS['%s']->pop();
	}}
	public $_DB;
	public $_path;
	public $_name;
	public $_expire;
	public $_loaded;
	public $__time__;
	public $data;
	public function get_data() {
		$GLOBALS['%s']->push("sirius.data.DataCache::get_data");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_DB;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function _now() {
		$GLOBALS['%s']->push("sirius.data.DataCache::_now");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = Date::now()->getTime();
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public $_validated;
	public function _checkPath() {
		$GLOBALS['%s']->push("sirius.data.DataCache::_checkPath");
		$__hx__spos = $GLOBALS['%s']->length;
		$p = _hx_explode("/", $this->_path);
		if($p->length > 0) {
			$t = (new _hx_array(array()));
			if($p[0] === "") {
				$t[0] = "/";
			} else {
				if($p[0] === ".") {
					$t[0] = "./";
				}
			}
			sirius_utils_Dice::Values($p, array(new _hx_lambda(array(&$p, &$t), "sirius_data_DataCache_0"), 'execute'), null);
		}
		$this->_name = _hx_string_or_null($this->_path) . "/" . _hx_string_or_null($this->_name);
		$this->_validated = true;
		$GLOBALS['%s']->pop();
	}
	public function _fixData() {
		$GLOBALS['%s']->push("sirius.data.DataCache::_fixData");
		$__hx__spos = $GLOBALS['%s']->length;
		$data = _hx_anonymous(array());
		$this->_fixParams($this->_DB, $data);
		php_Lib::dump($data);
		{
			$GLOBALS['%s']->pop();
			return $data;
		}
		$GLOBALS['%s']->pop();
	}
	public function _fixParams($from, $data) {
		$GLOBALS['%s']->push("sirius.data.DataCache::_fixParams");
		$__hx__spos = $GLOBALS['%s']->length;
		$i = null;
		sirius_utils_Dice::All($from, array(new _hx_lambda(array(&$data, &$from, &$i), "sirius_data_DataCache_1"), 'execute'), null);
		$GLOBALS['%s']->pop();
	}
	public function clear($p = null) {
		$GLOBALS['%s']->push("sirius.data.DataCache::clear");
		$__hx__spos = $GLOBALS['%s']->length;
		if($p !== null) {
			if($p !== "__time__") {
				Reflect::deleteField($this->_DB, $p);
			}
		} else {
			$this->_DB = _hx_anonymous(array());
			if($this->_expire > 0) {
				$this->_DB->__time__ = $this->_now();
			}
			@unlink($this->_path);
		}
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function set($p, $v) {
		$GLOBALS['%s']->push("sirius.data.DataCache::set");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_DB->{$p} = $v;
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function merge($p, $v) {
		$GLOBALS['%s']->push("sirius.data.DataCache::merge");
		$__hx__spos = $GLOBALS['%s']->length;
		if(Std::is($v, _hx_qtype("Array")) && _hx_has_field($this->_DB, $this->_name)) {
			$t = $this->get($p);
			if(Std::is($t, _hx_qtype("Array"))) {
				$tmp = $this->set($p, $t->concat($v));
				$GLOBALS['%s']->pop();
				return $tmp;
			}
		}
		$this->_DB->{$p} = $v;
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function get($id = null) {
		$GLOBALS['%s']->push("sirius.data.DataCache::get");
		$__hx__spos = $GLOBALS['%s']->length;
		$d = null;
		if($id !== null) {
			$d = Reflect::field($this->_DB, $id);
		} else {
			$d = null;
		}
		if($d === null) {
			$d = _hx_anonymous(array());
			$this->set($id, $d);
		}
		{
			$GLOBALS['%s']->pop();
			return $d;
		}
		$GLOBALS['%s']->pop();
	}
	public function exists($name = null) {
		$GLOBALS['%s']->push("sirius.data.DataCache::exists");
		$__hx__spos = $GLOBALS['%s']->length;
		if($name !== null) {
			$tmp = _hx_has_field($this->_DB, $this->_name);
			$GLOBALS['%s']->pop();
			return $tmp;
		} else {
			$tmp = $this->_loaded;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function save($base64 = null) {
		$GLOBALS['%s']->push("sirius.data.DataCache::save");
		$__hx__spos = $GLOBALS['%s']->length;
		if($base64 === null) {
			$base64 = true;
		}
		$data = null;
		if($base64) {
			$data = sirius_utils_Criptog::encodeBase64($this->_DB);
		} else {
			$data = $this->json(false);
		}
		if(!$this->_validated) {
			$this->_checkPath();
		}
		if($this->_expire > 0) {
			$this->_sign(true);
		}
		sys_io_File::saveContent($this->_name, $data);
		if($this->_expire > 0) {
			$this->_sign(false);
		}
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function _sign($add) {
		$GLOBALS['%s']->push("sirius.data.DataCache::_sign");
		$__hx__spos = $GLOBALS['%s']->length;
		if($add) {
			$this->_DB->__time__ = $this->_now();
		} else {
			if($this->_expire > 0) {
				$this->__time__ = $this->_DB->__time__;
			} else {
				$this->__time__ = 0;
			}
			Reflect::deleteField($this->_DB, "__time__");
		}
		$GLOBALS['%s']->pop();
	}
	public function load($base64 = null) {
		$GLOBALS['%s']->push("sirius.data.DataCache::load");
		$__hx__spos = $GLOBALS['%s']->length;
		if($base64 === null) {
			$base64 = true;
		}
		$this->_DB = null;
		if(!$this->_validated) {
			$this->_checkPath();
		}
		if(file_exists($this->_name)) {
			$c = sys_io_File::getContent($this->_name);
			if($base64) {
				$this->_DB = sirius_utils_Criptog::decodeBase64($c, true);
			} else {
				$this->_DB = haxe_Json::phpJsonDecode($c);
			}
		}
		if(_hx_field($this, "_DB") === null || $this->_expire !== 0 && (_hx_field($this->_DB, "__time__") === null || $this->_now() - $this->_DB->__time__ >= $this->_expire)) {
			$this->_DB = _hx_anonymous(array());
			$this->_loaded = false;
		} else {
			$this->_sign(false);
			$this->_loaded = true;
		}
		{
			$tmp = $this->_loaded;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function refresh() {
		$GLOBALS['%s']->push("sirius.data.DataCache::refresh");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->__time__ = $this->_now();
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function json($print = null) {
		$GLOBALS['%s']->push("sirius.data.DataCache::json");
		$__hx__spos = $GLOBALS['%s']->length;
		$result = haxe_Json::phpJsonEncode($this->_DB, null, null);
		if($print) {
			php_Lib::hprint($result);
		}
		{
			$GLOBALS['%s']->pop();
			return $result;
		}
		$GLOBALS['%s']->pop();
	}
	public function base64($print = null) {
		$GLOBALS['%s']->push("sirius.data.DataCache::base64");
		$__hx__spos = $GLOBALS['%s']->length;
		$result = sirius_utils_Criptog::encodeBase64($this->_DB);
		if($print) {
			php_Lib::hprint($result);
		}
		{
			$GLOBALS['%s']->pop();
			return $result;
		}
		$GLOBALS['%s']->pop();
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
	static $__properties__ = array("get_data" => "get_data");
	function __toString() { return 'sirius.data.DataCache'; }
}
function sirius_data_DataCache_0(&$p, &$t, $v) {
	{
		$GLOBALS['%s']->push("sirius.data.DataCache::_checkPath@64");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if(sirius_tools_Utils::isValid($v)) {
			$t[$t->length] = $v;
			$v = $t->join("/");
			if(!file_exists($v)) {
				$path = haxe_io_Path::addTrailingSlash($v);
				$_p = null;
				$parts = (new _hx_array(array()));
				while($path !== ($_p = haxe_io_Path::directory($path))) {
					$parts->unshift($path);
					$path = $_p;
				}
				{
					$_g = 0;
					while($_g < $parts->length) {
						$part = $parts[$_g];
						++$_g;
						if(_hx_char_code_at($part, strlen($part) - 1) !== 58 && !file_exists($part)) {
							@mkdir($part, 493);
						}
						unset($part);
					}
				}
			}
			{
				$GLOBALS['%s']->pop();
				return false;
			}
		}
		{
			$GLOBALS['%s']->pop();
			return true;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_data_DataCache_1(&$data, &$from, &$i, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.data.DataCache::_fixParams@87");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if(Std::is($v, _hx_qtype("Float")) || Std::is($v, _hx_qtype("Bool")) || Std::is($v, _hx_qtype("String")) || Std::is($v, _hx_qtype("Int"))) {
			$field = $p;
			$data->{$field} = $v;
		} else {
			if(Std::is($v, _hx_qtype("Array"))) {
				$v = php_Lib::toPhpArray($v);
			} else {
				if(Std::is($v, _hx_qtype("Dynamic"))) {
					$v = php_Lib::associativeArrayOfObject($v);
				}
			}
		}
		{
			$field1 = $p;
			$data->{$field1} = $v;
		}
		$GLOBALS['%s']->pop();
	}
}
