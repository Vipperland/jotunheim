<?php

class sirius_modules_Loader implements sirius_modules_ILoader{
	public function __construct($noCache = null) {
		if(!php_Boot::$skip_constructor) {
		if($noCache === null) {
			$noCache = false;
		}
		$this->_toload = (new _hx_array(array()));
		$this->_noCache = $noCache;
	}}
	public $_toload;
	public $_complete;
	public $_isBusy;
	public $_error;
	public $_noCache;
	public function add($files, $complete = null, $error = null) {
		if(_hx_field($this, "_error") !== null) {
			$this->_error = $error;
		}
		if($complete !== null) {
			$this->_complete = $complete;
		}
		if($files !== null && $files->length > 0) {
			$this->_toload = $this->_toload->concat($files);
		}
		return $this;
	}
	public function start() {
		if(!$this->_isBusy) {
			$this->_isBusy = true;
			$this->_loadNext();
		}
		return $this;
	}
	public function _loadNext() {
		$_g = $this;
		if($this->_toload->length > 0) {
			$f = $this->_toload->shift();
			$r = new haxe_Http(_hx_string_or_null($f) . _hx_string_or_null((sirius_modules_Loader_0($this, $_g, $f))));
			$r->onError = array(new _hx_lambda(array(&$_g, &$f, &$r), "sirius_modules_Loader_1"), 'execute');
			$r->onData = array(new _hx_lambda(array(&$_g, &$f, &$r), "sirius_modules_Loader_2"), 'execute');
			$r->request(false);
		} else {
			$this->_isBusy = false;
			if(_hx_field($this, "_complete") !== null) {
				$this->_complete($this);
			}
		}
	}
	public function get($module, $data = null) {
		return sirius_modules_ModLib::get($module, $data);
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
	static function FILES() { $args = func_get_args(); return call_user_func_array(self::$FILES, $args); }
	static $FILES;
	function __toString() { return 'sirius.modules.Loader'; }
}
sirius_modules_Loader::$FILES = _hx_anonymous(array());
function sirius_modules_Loader_0(&$__hx__this, &$_g, &$f) {
	if($__hx__this->_noCache) {
		return "";
	} else {
		return "?t=" . _hx_string_rec(Date::now()->getTime(), "");
	}
}
function sirius_modules_Loader_1(&$_g, &$f, &$r, $e) {
	{
		if(_hx_field($_g, "_error") !== null) {
			$_g->_error($e);
		}
		$_g->_loadNext();
	}
}
function sirius_modules_Loader_2(&$_g, &$f, &$r, $d) {
	{
		sirius_modules_ModLib::register($f, $d);
		$_g->_loadNext();
	}
}
