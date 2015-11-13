<?php

class sirius_modules_Loader implements sirius_modules_ILoader{
	public function __construct($noCache = null) {
		if(!php_Boot::$skip_constructor) {
		if($noCache === null) {
			$noCache = false;
		}
		$this->_toload = (new _hx_array(array()));
		$this->_noCache = $noCache;
		$this->_onComplete = (new _hx_array(array()));
		$this->_onError = (new _hx_array(array()));
		$this->_onChange = (new _hx_array(array()));
		$this->totalLoaded = 0;
		$this->totalFiles = 0;
	}}
	public $_toload;
	public $_onChange;
	public $_onComplete;
	public $_onError;
	public $_isBusy;
	public $_noCache;
	public $totalFiles;
	public $totalLoaded;
	public $lastError;
	public function progress() {
		return $this->totalLoaded / $this->totalFiles;
	}
	public function unlisten($handler = null) {
		$i = -1;
		if($handler !== null) {
			$i = Lambda::indexOf($this->_onComplete, $handler);
			if($i !== -1) {
				$this->_onComplete->splice($i, 1);
			}
			$i = Lambda::indexOf($this->_onError, $handler);
			if($i !== -1) {
				$this->_onError->splice($i, 1);
			}
		}
		return $this;
	}
	public function onChange($handler) {
		if($handler !== null) {
			$this->_onChange[$this->_onChange->length] = $handler;
		}
	}
	public function listen($complete = null, $error = null) {
		if($error !== null && Lambda::indexOf($this->_onError, $error) === -1) {
			$this->_onError[$this->_onError->length] = $error;
		}
		if($complete !== null && Lambda::indexOf($this->_onComplete, $complete) === -1) {
			$this->_onComplete[$this->_onComplete->length] = $complete;
		}
		return $this;
	}
	public function add($files, $complete = null, $error = null) {
		$this->listen($complete, $error);
		if($files !== null && $files->length > 0) {
			$this->_toload = $this->_toload->concat($files);
			$this->totalFiles += $files->length;
		}
		return $this;
	}
	public function start($complete = null, $error = null) {
		if(!$this->_isBusy) {
			$this->listen($complete, $error);
			$this->_isBusy = true;
			$this->_loadNext();
		}
		return $this;
	}
	public function _changed($req, $url, $status, $data = null) {
		sirius_utils_Dice::Values($this->_onChange, array(new _hx_lambda(array(&$data, &$req, &$status, &$url), "sirius_modules_Loader_0"), 'execute'), null);
	}
	public function _loadNext() {
		$_g = $this;
		if($this->_toload->length > 0) {
			$f = $this->_toload->shift();
			$r = new haxe_Http(_hx_string_or_null($f) . _hx_string_or_null((sirius_modules_Loader_1($this, $_g, $f))));
			$this->_changed($r, $f, "started", null);
			$r->onError = array(new _hx_lambda(array(&$_g, &$f, &$r), "sirius_modules_Loader_2"), 'execute');
			$r->onData = array(new _hx_lambda(array(&$_g, &$f, &$r), "sirius_modules_Loader_3"), 'execute');
			$r->request(false);
		} else {
			$this->_isBusy = false;
			$this->_complete();
		}
	}
	public function _error($e) {
		$_g = $this;
		if(Std::is($e, _hx_qtype("String"))) {
			$this->lastError = new sirius_errors_Error(-1, $e, $this);
		} else {
			$this->lastError = new sirius_errors_Error(-1, "Unknow", _hx_anonymous(array("content" => $e, "loader" => $this)));
		}
		sirius_utils_Dice::Values($this->_onError, array(new _hx_lambda(array(&$_g, &$e), "sirius_modules_Loader_4"), 'execute'), null);
	}
	public function _complete() {
		$_g = $this;
		sirius_utils_Dice::Values($this->_onComplete, array(new _hx_lambda(array(&$_g), "sirius_modules_Loader_5"), 'execute'), null);
		$this->_onComplete = (new _hx_array(array()));
		$this->_onError = (new _hx_array(array()));
	}
	public function async($file, $data = null, $handler = null) {
		$_g = $this;
		$h = null;
		if(_hx_index_of($file, "#", null) !== -1) {
			$h = _hx_explode("#", $file);
		} else {
			$h = (new _hx_array(array($file)));
		}
		$r = new haxe_Http(_hx_string_or_null($h[0]) . _hx_string_or_null((sirius_modules_Loader_6($this, $_g, $data, $file, $h, $handler))));
		$this->_changed($r, $file, "started", null);
		$r->onData = array(new _hx_lambda(array(&$_g, &$data, &$file, &$h, &$handler, &$r), "sirius_modules_Loader_7"), 'execute');
		$r->onError = array(new _hx_lambda(array(&$_g, &$data, &$file, &$h, &$handler, &$r), "sirius_modules_Loader_8"), 'execute');
		$r->request(false);
	}
	public function request($url, $data = null, $handler = null, $method = null) {
		if($method === null) {
			$method = "post";
		}
		$_g = $this;
		$r = new haxe_Http(_hx_string_or_null($url) . _hx_string_or_null((sirius_modules_Loader_9($this, $_g, $data, $handler, $method, $url))));
		$this->_changed($r, $url, "started", null);
		if($data !== null) {
			sirius_utils_Dice::All($data, (isset($r->setParameter) ? $r->setParameter: array($r, "setParameter")), null);
		}
		$r->onData = array(new _hx_lambda(array(&$_g, &$data, &$handler, &$method, &$r, &$url), "sirius_modules_Loader_10"), 'execute');
		$r->onError = array(new _hx_lambda(array(&$_g, &$data, &$handler, &$method, &$r, &$url), "sirius_modules_Loader_11"), 'execute');
		$r->request($method === null || strtolower($method) === "post");
	}
	public function get($module, $data = null) {
		return sirius_Sirius::$resources->get($module, $data);
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
function sirius_modules_Loader_0(&$data, &$req, &$status, &$url, $v) {
	{
		call_user_func_array($v, array($req, $url, $status, $data));
	}
}
function sirius_modules_Loader_1(&$__hx__this, &$_g, &$f) {
	if($__hx__this->_noCache) {
		return "";
	} else {
		return "?t=" . _hx_string_rec(Date::now()->getTime(), "");
	}
}
function sirius_modules_Loader_2(&$_g, &$f, &$r, $e) {
	{
		$_g->_changed($r, $f, "error", $e);
		++$_g->totalLoaded;
		if($_g->_error !== null) {
			$_g->_error($e);
		}
		$_g->_loadNext();
	}
}
function sirius_modules_Loader_3(&$_g, &$f, &$r, $d) {
	{
		$_g->_changed($r, $f, "complete", $d);
		++$_g->totalLoaded;
		sirius_Sirius::$resources->register($f, $d);
		$_g->_loadNext();
	}
}
function sirius_modules_Loader_4(&$_g, &$e, $v) {
	{
		if($v !== null) {
			call_user_func_array($v, array($_g->lastError));
		}
	}
}
function sirius_modules_Loader_5(&$_g, $v) {
	{
		if($v !== null) {
			call_user_func_array($v, array($_g));
		}
	}
}
function sirius_modules_Loader_6(&$__hx__this, &$_g, &$data, &$file, &$h, &$handler) {
	if($__hx__this->_noCache) {
		return "";
	} else {
		return "?t=" . _hx_string_rec(Date::now()->getTime(), "");
	}
}
function sirius_modules_Loader_7(&$_g, &$data, &$file, &$h, &$handler, &$r, $d) {
	{
		$_g->_changed($r, $file, "complete", $d);
		sirius_Sirius::$resources->register($file, $d);
		if($h->length === 2) {
			$file = $h[1];
		} else {
			$file = $file;
		}
		if($handler !== null) {
			call_user_func_array($handler, array($file, $d));
		}
	}
}
function sirius_modules_Loader_8(&$_g, &$data, &$file, &$h, &$handler, &$r, $d1) {
	{
		$_g->_changed($r, $file, "error", $d1);
		if($handler !== null) {
			call_user_func_array($handler, array(null, $d1));
		}
	}
}
function sirius_modules_Loader_9(&$__hx__this, &$_g, &$data, &$handler, &$method, &$url) {
	if($__hx__this->_noCache) {
		return "";
	} else {
		return "?t=" . _hx_string_rec(Date::now()->getTime(), "");
	}
}
function sirius_modules_Loader_10(&$_g, &$data, &$handler, &$method, &$r, &$url, $d) {
	{
		$_g->_changed($r, $url, "complete", $d);
		if($handler !== null) {
			call_user_func_array($handler, array(new sirius_modules_Request(true, $d, null)));
		}
	}
}
function sirius_modules_Loader_11(&$_g, &$data, &$handler, &$method, &$r, &$url, $d1) {
	{
		$_g->_changed($r, $url, "error", $d1);
		if($handler !== null) {
			call_user_func_array($handler, array(new sirius_modules_Request(false, null, new sirius_errors_Error(-1, $d1, null))));
		}
	}
}
