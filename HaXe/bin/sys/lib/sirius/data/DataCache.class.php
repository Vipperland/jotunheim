<?php

class sirius_data_DataCache implements sirius_data_IDataCache{
	public function __construct($name = null, $path = null, $expire = null, $base64 = null) {
		if(!php_Boot::$skip_constructor) {
		if($expire === null) {
			$expire = 0;
		}
		$this->_validated = false;
		$this->_name = $name;
		$this->_path = $path;
		$this->_expire = $expire;
		$this->_base64 = $base64;
		$this->clear(null);
	}}
	public $_DB;
	public $_path;
	public $_name;
	public $_expire;
	public $_loaded;
	public $_base64;
	public $__time__;
	public $data;
	public function get_data() {
		return $this->_DB;
	}
	public function _now() {
		return Date::now()->getTime();
	}
	public $_validated;
	public function _checkPath() {
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
	}
	public function _fixData() {
		$data = _hx_anonymous(array());
		$this->_fixParams($this->_DB, $data);
		php_Lib::dump($data);
		return $data;
	}
	public function _fixParams($from, $data) {
		$i = null;
		sirius_utils_Dice::All($from, array(new _hx_lambda(array(&$data, &$from, &$i), "sirius_data_DataCache_1"), 'execute'), null);
	}
	public function clear($p = null) {
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
		return $this;
	}
	public function set($p, $v) {
		$this->_DB->{$p} = $v;
		return $this;
	}
	public function merge($p, $v) {
		if(Std::is($v, _hx_qtype("Array")) && _hx_has_field($this->_DB, $this->_name)) {
			$t = $this->get($p);
			if(Std::is($t, _hx_qtype("Array"))) {
				return $this->set($p, $t->concat($v));
			}
		}
		$this->_DB->{$p} = $v;
		return $this;
	}
	public function get($id = null) {
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
		return $d;
	}
	public function exists($name = null) {
		if($name !== null) {
			return _hx_has_field($this->_DB, $name);
		} else {
			return $this->_loaded;
		}
	}
	public function save() {
		$data = null;
		if($this->_base64) {
			$data = sirius_serial_IOTools::encodeBase64($this->_DB);
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
		return $this;
	}
	public function _sign($add) {
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
	}
	public function load() {
		$this->_DB = null;
		if(!$this->_validated) {
			$this->_checkPath();
		}
		if(file_exists($this->_name)) {
			$c = sys_io_File::getContent($this->_name);
			if($this->_base64) {
				$this->_DB = sirius_serial_IOTools::decodeBase64($c, true);
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
		return $this->_loaded;
	}
	public function refresh() {
		$this->__time__ = $this->_now();
		return $this;
	}
	public function json($print = null) {
		$result = sirius_serial_JsonTool::stringfy($this->_DB, null, " ");
		if($print) {
			php_Lib::hprint($result);
		}
		return $result;
	}
	public function base64($print = null) {
		$result = sirius_serial_IOTools::encodeBase64($this->_DB);
		if($print) {
			php_Lib::hprint($result);
		}
		return $result;
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
			return false;
		}
		return true;
	}
}
function sirius_data_DataCache_1(&$data, &$from, &$i, $p, $v) {
	{
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
	}
}
