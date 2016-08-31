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
		$this->signals = new sirius_signals_Signals($this);
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
	public $signals;
	public function _getReq($u) {
		return new sirius_net_HttpRequest(_hx_string_or_null($u) . _hx_string_or_null((sirius_modules_Loader_0($this, $u))));
	}
	public function progress() {
		return $this->totalLoaded / $this->totalFiles;
	}
	public function add($files) {
		if($files !== null && $files->length > 0) {
			$this->_toload = $this->_toload->concat($files);
			$this->totalFiles += $files->length;
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
	public function _changed($file, $status, $data = null) {
		$this->signals->call($status, _hx_anonymous(array("file" => $file, "data" => $data)));
	}
	public function _loadNext() {
		$_g = $this;
		if($this->_toload->length > 0) {
			$f = $this->_toload->shift();
			$r = $this->_getReq($f);
			$this->_changed($f, "started", null);
			$r->onError = array(new _hx_lambda(array(&$_g, &$f, &$r), "sirius_modules_Loader_1"), 'execute');
			$r->onData = array(new _hx_lambda(array(&$_g, &$f, &$r), "sirius_modules_Loader_2"), 'execute');
			$r->request(false);
		} else {
			$this->_isBusy = false;
			$this->_complete();
		}
	}
	public function _error($e) {
		if(Std::is($e, _hx_qtype("String"))) {
			$this->lastError = new sirius_errors_Error(-1, $e, $this);
		} else {
			$this->lastError = new sirius_errors_Error(-1, "Unknow", _hx_anonymous(array("content" => $e, "loader" => $this)));
		}
		$this->signals->call("error", $this->lastError);
	}
	public function _complete() {
		$this->signals->call("complete", null);
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
		$r = $this->_getReq($h[0]);
		$this->_changed($file, "started", null);
		$r->onData = array(new _hx_lambda(array(&$_g, &$data, &$file, &$h, &$handler, &$r), "sirius_modules_Loader_3"), 'execute');
		$r->onError = array(new _hx_lambda(array(&$_g, &$data, &$file, &$h, &$handler, &$r), "sirius_modules_Loader_4"), 'execute');
		$r->request(false);
	}
	public function request($url, $data = null, $handler = null, $method = null) {
		if($method === null) {
			$method = "POST";
		}
		$_g = $this;
		$r = $this->_getReq($url);
		$this->_changed($url, "started", null);
		if($data !== null) {
			sirius_utils_Dice::All($data, (isset($r->setParameter) ? $r->setParameter: array($r, "setParameter")), null);
		}
		$r->onData = array(new _hx_lambda(array(&$_g, &$data, &$handler, &$method, &$r, &$url), "sirius_modules_Loader_5"), 'execute');
		$r->onError = array(new _hx_lambda(array(&$_g, &$data, &$handler, &$method, &$r, &$url), "sirius_modules_Loader_6"), 'execute');
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
function sirius_modules_Loader_0(&$__hx__this, &$u) {
	if($__hx__this->_noCache) {
		return "";
	} else {
		return "?t=" . _hx_string_rec(Date::now()->getTime(), "");
	}
}
function sirius_modules_Loader_1(&$_g, &$f, &$r, $e) {
	{
		$_g->_changed($f, "error", $e);
		++$_g->totalLoaded;
		$_g->_loadNext();
	}
}
function sirius_modules_Loader_2(&$_g, &$f, &$r, $d) {
	{
		$_g->_changed($f, "loaded", $d);
		++$_g->totalLoaded;
		sirius_Sirius::$resources->register($f, $d);
		$_g->_loadNext();
	}
}
function sirius_modules_Loader_3(&$_g, &$data, &$file, &$h, &$handler, &$r, $d) {
	{
		$_g->_changed($file, "loaded", $d);
		sirius_Sirius::$resources->register($file, $d);
		if($handler !== null) {
			call_user_func_array($handler, array($file, $d));
		}
	}
}
function sirius_modules_Loader_4(&$_g, &$data, &$file, &$h, &$handler, &$r, $d1) {
	{
		$_g->_changed($file, "error", $d1);
		if($handler !== null) {
			call_user_func_array($handler, array(null, $d1));
		}
	}
}
function sirius_modules_Loader_5(&$_g, &$data, &$handler, &$method, &$r, &$url, $d) {
	{
		$_g->_changed($url, "loaded", $d);
		if($handler !== null) {
			call_user_func_array($handler, array(new sirius_modules_Request(true, $d, null)));
		}
	}
}
function sirius_modules_Loader_6(&$_g, &$data, &$handler, &$method, &$r, &$url, $d1) {
	{
		$_g->_changed($url, "error", $d1);
		if($handler !== null) {
			call_user_func_array($handler, array(new sirius_modules_Request(false, null, new sirius_errors_Error(-1, $d1, null))));
		}
	}
}
