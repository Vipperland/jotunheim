<?php

class sirius_data_DataCache implements sirius_data_IDataCache{
	public function __construct($name, $path, $expire = null) {
		if(!php_Boot::$skip_constructor) {
		if($expire === null) {
			$expire = 0;
		}
		$this->_validated = false;
		$this->_name = $name;
		$this->_expire = $expire;
		$this->_path = $path;
		$this->clear(null);
	}}
	public $_DB;
	public $_path;
	public $_name;
	public $_expire;
	public function _now() {
		return Date::now()->getTime();
	}
	public $_validated;
	public function _checkPath() {
		$p = _hx_explode("/", _hx_explode("\\", $this->_path)->join("/"));
		if($p->length > 0) {
			$t = (new _hx_array(array()));
			sirius_utils_Dice::Values($p, array(new _hx_lambda(array(&$p, &$t), "sirius_data_DataCache_0"), 'execute'), null);
		}
		$this->_name = _hx_string_or_null($this->_path) . "/" . _hx_string_or_null($this->_name) . ".cache";
	}
	public function json($print = null) {
		$result = json_encode($this,256);
		if($print) {
			php_Lib::hprint($result);
		}
		return $result;
	}
	public function clear($p = null) {
		if($p !== null) {
			Reflect::deleteField($this->_DB, $p);
		} else {
			if($p !== "__time__") {
				$this->_DB = _hx_anonymous(array("__time__" => $this->_now()));
				@unlink($this->_path);
			}
		}
		return $this;
	}
	public function set($p, $v) {
		if(Std::is($v, _hx_qtype("Array")) && _hx_has_field($this->_DB, $this->_name)) {
			$t = $this->get($p);
			if(Std::is($t, _hx_qtype("Array"))) {
				{
					$value = $t->concat($v);
					$this->_DB->{$p} = $value;
				}
				return $this;
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
	public function exists($name) {
		return _hx_has_field($this->_DB, $this->_name);
	}
	public function save() {
		if(!$this->_validated) {
			$this->_checkPath();
		}
		$this->_DB->__exists__ = true;
		sys_io_File::saveContent($this->_name, $this->base64());
		return $this;
	}
	public function load() {
		if(!$this->_validated) {
			$this->_checkPath();
		}
		if(file_exists($this->_name)) {
			$c = sys_io_File::getContent($this->_name);
			if(strlen($c) > 0) {
				$c = haxe_crypto_Base64::decode($c, null)->toString();
			}
			if($c !== null && strlen($c) > 1) {
				$this->_DB = haxe_Json::phpJsonDecode($c);
			}
		}
		if(_hx_field($this->_DB, "__time__") === null || $this->_now() - $this->_DB->__time__ >= $this->_expire) {
			$this->_DB = _hx_anonymous(array("__time__" => $this->_now(), "__exists__" => false));
		}
		return $this;
	}
	public function refresh() {
		if($this->_DB->__exists__) {
			$this->_DB->__time__ = $this->_now();
		}
		return $this;
	}
	public function getData() {
		return $this->_DB;
	}
	public function base64() {
		return haxe_crypto_Base64::encode(haxe_io_Bytes::ofString($this->json(null)), null);
	}
	public function isExpired() {
		return _hx_field($this, "_DB") !== null && _hx_equal($this->_DB->__exists__, true);
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
