<?php

class sirius_modules_Loader implements sirius_modules_ILoader{
	public function __construct($noCache = null) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.modules.Loader::new");
		$__hx__spos = $GLOBALS['%s']->length;
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
		$GLOBALS['%s']->pop();
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
		$GLOBALS['%s']->push("sirius.modules.Loader::progress");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->totalLoaded / $this->totalFiles;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function unlisten($handler = null) {
		$GLOBALS['%s']->push("sirius.modules.Loader::unlisten");
		$__hx__spos = $GLOBALS['%s']->length;
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
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function onChange($handler) {
		$GLOBALS['%s']->push("sirius.modules.Loader::onChange");
		$__hx__spos = $GLOBALS['%s']->length;
		if($handler !== null) {
			$this->_onChange[$this->_onChange->length] = $handler;
		}
		$GLOBALS['%s']->pop();
	}
	public function listen($complete = null, $error = null) {
		$GLOBALS['%s']->push("sirius.modules.Loader::listen");
		$__hx__spos = $GLOBALS['%s']->length;
		if($error !== null && Lambda::indexOf($this->_onError, $error) === -1) {
			$this->_onError[$this->_onError->length] = $error;
		}
		if($complete !== null && Lambda::indexOf($this->_onComplete, $complete) === -1) {
			$this->_onComplete[$this->_onComplete->length] = $complete;
		}
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function add($files, $complete = null, $error = null) {
		$GLOBALS['%s']->push("sirius.modules.Loader::add");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->listen($complete, $error);
		if($files !== null && $files->length > 0) {
			$this->_toload = $this->_toload->concat($files);
			$this->totalFiles += $files->length;
		}
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function start($complete = null, $error = null) {
		$GLOBALS['%s']->push("sirius.modules.Loader::start");
		$__hx__spos = $GLOBALS['%s']->length;
		if(!$this->_isBusy) {
			$this->listen($complete, $error);
			$this->_isBusy = true;
			$this->_loadNext();
		}
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function _changed($req, $url, $status, $data = null) {
		$GLOBALS['%s']->push("sirius.modules.Loader::_changed");
		$__hx__spos = $GLOBALS['%s']->length;
		sirius_utils_Dice::Values($this->_onChange, array(new _hx_lambda(array(&$data, &$req, &$status, &$url), "sirius_modules_Loader_0"), 'execute'), null);
		$GLOBALS['%s']->pop();
	}
	public function _loadNext() {
		$GLOBALS['%s']->push("sirius.modules.Loader::_loadNext");
		$__hx__spos = $GLOBALS['%s']->length;
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
		$GLOBALS['%s']->pop();
	}
	public function _error($e) {
		$GLOBALS['%s']->push("sirius.modules.Loader::_error");
		$__hx__spos = $GLOBALS['%s']->length;
		$_g = $this;
		if(Std::is($e, _hx_qtype("String"))) {
			$this->lastError = new sirius_errors_Error(-1, $e, $this);
		} else {
			$this->lastError = new sirius_errors_Error(-1, "Unknow", _hx_anonymous(array("content" => $e, "loader" => $this)));
		}
		sirius_utils_Dice::Values($this->_onError, array(new _hx_lambda(array(&$_g, &$e), "sirius_modules_Loader_4"), 'execute'), null);
		$GLOBALS['%s']->pop();
	}
	public function _complete() {
		$GLOBALS['%s']->push("sirius.modules.Loader::_complete");
		$__hx__spos = $GLOBALS['%s']->length;
		$_g = $this;
		sirius_utils_Dice::Values($this->_onComplete, array(new _hx_lambda(array(&$_g), "sirius_modules_Loader_5"), 'execute'), null);
		$this->_onComplete = (new _hx_array(array()));
		$this->_onError = (new _hx_array(array()));
		$GLOBALS['%s']->pop();
	}
	public function async($file, $data = null, $handler = null) {
		$GLOBALS['%s']->push("sirius.modules.Loader::async");
		$__hx__spos = $GLOBALS['%s']->length;
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
		$GLOBALS['%s']->pop();
	}
	public function request($url, $data = null, $handler = null, $method = null) {
		$GLOBALS['%s']->push("sirius.modules.Loader::request");
		$__hx__spos = $GLOBALS['%s']->length;
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
		$GLOBALS['%s']->pop();
	}
	public function get($module, $data = null) {
		$GLOBALS['%s']->push("sirius.modules.Loader::get");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = sirius_Sirius::$resources->get($module, $data);
			$GLOBALS['%s']->pop();
			return $tmp;
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
	static function FILES() { $args = func_get_args(); return call_user_func_array(self::$FILES, $args); }
	static $FILES;
	function __toString() { return 'sirius.modules.Loader'; }
}
sirius_modules_Loader::$FILES = _hx_anonymous(array());
function sirius_modules_Loader_0(&$data, &$req, &$status, &$url, $v) {
	{
		$GLOBALS['%s']->push("sirius.modules.Loader::_changed@94");
		$__hx__spos2 = $GLOBALS['%s']->length;
		call_user_func_array($v, array($req, $url, $status, $data));
		$GLOBALS['%s']->pop();
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
		$GLOBALS['%s']->push("sirius.modules.Loader::_loadNext@107");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$_g->_changed($r, $f, "error", $e);
		++$_g->totalLoaded;
		if($_g->_error !== null) {
			$_g->_error($e);
		}
		$_g->_loadNext();
		$GLOBALS['%s']->pop();
	}
}
function sirius_modules_Loader_3(&$_g, &$f, &$r, $d) {
	{
		$GLOBALS['%s']->push("sirius.modules.Loader::_loadNext@113");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$_g->_changed($r, $f, "complete", $d);
		++$_g->totalLoaded;
		sirius_Sirius::$resources->register($f, $d);
		$_g->_loadNext();
		$GLOBALS['%s']->pop();
	}
}
function sirius_modules_Loader_4(&$_g, &$e, $v) {
	{
		$GLOBALS['%s']->push("sirius.modules.Loader::_error@128");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if($v !== null) {
			call_user_func_array($v, array($_g->lastError));
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_modules_Loader_5(&$_g, $v) {
	{
		$GLOBALS['%s']->push("sirius.modules.Loader::_complete@134");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if($v !== null) {
			call_user_func_array($v, array($_g));
		}
		$GLOBALS['%s']->pop();
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
		$GLOBALS['%s']->push("sirius.modules.Loader::async@156");
		$__hx__spos2 = $GLOBALS['%s']->length;
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
		$GLOBALS['%s']->pop();
	}
}
function sirius_modules_Loader_8(&$_g, &$data, &$file, &$h, &$handler, &$r, $d1) {
	{
		$GLOBALS['%s']->push("sirius.modules.Loader::async@179");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$_g->_changed($r, $file, "error", $d1);
		if($handler !== null) {
			call_user_func_array($handler, array(null, $d1));
		}
		$GLOBALS['%s']->pop();
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
		$GLOBALS['%s']->push("sirius.modules.Loader::request@193");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$_g->_changed($r, $url, "complete", $d);
		if($handler !== null) {
			call_user_func_array($handler, array(new sirius_modules_Request(true, $d, null)));
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_modules_Loader_11(&$_g, &$data, &$handler, &$method, &$r, &$url, $d1) {
	{
		$GLOBALS['%s']->push("sirius.modules.Loader::request@197");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$_g->_changed($r, $url, "error", $d1);
		if($handler !== null) {
			call_user_func_array($handler, array(new sirius_modules_Request(false, null, new sirius_errors_Error(-1, $d1, null))));
		}
		$GLOBALS['%s']->pop();
	}
}
