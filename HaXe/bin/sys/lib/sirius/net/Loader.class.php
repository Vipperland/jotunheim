<?php

class sirius_net_Loader implements sirius_net_ILoader{
	public function __construct($noCache = null) {
		if(!php_Boot::$skip_constructor) {
		if($noCache === null) {
			$noCache = false;
		}
		$this->_toload = (new _hx_array(array()));
		$this->_noCache = $noCache;
		$this->signals = new sirius_signals_Signals($this);
		$this->totalLoaded = 0;
		$this->totalFiles = 0;
	}}
	public $_toload;
	public $_isBusy;
	public $_noCache;
	public $totalFiles;
	public $totalLoaded;
	public $lastError;
	public $signals;
	public function _getReq($u) {
		return new sirius_net_HttpRequest($u);
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
	public function _changed($file, $status, $data = null, $request = null) {
		$this->signals->call($status, _hx_anonymous(array("file" => $file, "data" => $data, "request" => $request)));
	}
	public function _loadNext() {
		$_g = $this;
		if($this->_toload->length > 0) {
			$f = $this->_toload->shift();
			$r = $this->_getReq($f);
			$this->_changed($f, "started", null, $r);
			$r->onError = array(new _hx_lambda(array(&$_g, &$f, &$r), "sirius_net_Loader_0"), 'execute');
			$r->onData = array(new _hx_lambda(array(&$_g, &$f, &$r), "sirius_net_Loader_1"), 'execute');
			$r->request(null);
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
		$this->signals->call("completed", null);
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
		$this->_changed($file, "started", $data, $r);
		$r->onData = array(new _hx_lambda(array(&$_g, &$data, &$file, &$h, &$handler, &$r), "sirius_net_Loader_2"), 'execute');
		$r->onError = array(new _hx_lambda(array(&$_g, &$data, &$file, &$h, &$handler, &$r), "sirius_net_Loader_3"), 'execute');
		$r->request(false);
	}
	public function request($url, $data = null, $method = null, $handler = null, $headers = null) {
		if($method === null) {
			$method = "POST";
		}
		$_g = $this;
		if($method === null || $method === "") {
			$method = "POST";
		} else {
			$method = strtoupper($method);
		}
		$is_post = $method === "POST";
		$is_get = $method === "GET";
		$is_data = Std::is($data, _hx_qtype("String"));
		if($method === "GET") {
			$ps = _hx_explode("?", $url);
			if($ps->length === 1 || strlen($ps[1]) === 0) {
				$ps[1] = sirius_tools_Utils::paramsOf($data);
			} else {
				$ps->a[1] .= "&" . _hx_string_or_null(sirius_tools_Utils::paramsOf($data));
			}
			$url = $ps->join("?");
		}
		$r = $this->_getReq($url);
		$this->_changed($url, "started", $data, $r);
		if(!$is_data && $data !== null) {
			sirius_utils_Dice::All($data, (isset($r->setParameter) ? $r->setParameter: array($r, "setParameter")), null);
		}
		if($headers !== null) {
			sirius_utils_Dice::All($headers, array(new _hx_lambda(array(&$_g, &$data, &$handler, &$headers, &$is_data, &$is_get, &$is_post, &$method, &$r, &$url), "sirius_net_Loader_4"), 'execute'), null);
		}
		$r->onData = array(new _hx_lambda(array(&$_g, &$data, &$handler, &$headers, &$is_data, &$is_get, &$is_post, &$method, &$r, &$url), "sirius_net_Loader_5"), 'execute');
		$r->onError = array(new _hx_lambda(array(&$_g, &$data, &$handler, &$headers, &$is_data, &$is_get, &$is_post, &$method, &$r, &$url), "sirius_net_Loader_6"), 'execute');
		$r->request($is_post);
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
	function __toString() { return 'sirius.net.Loader'; }
}
sirius_net_Loader::$FILES = _hx_anonymous(array());
function sirius_net_Loader_0(&$_g, &$f, &$r, $e) {
	{
		$_g->_changed($f, "error", $e, $r);
		++$_g->totalLoaded;
		$_g->_loadNext();
	}
}
function sirius_net_Loader_1(&$_g, &$f, &$r, $d) {
	{
		$_g->_changed($f, "loaded", $d, $r);
		++$_g->totalLoaded;
		sirius_Sirius::$resources->register($f, $d);
		$_g->_loadNext();
	}
}
function sirius_net_Loader_2(&$_g, &$data, &$file, &$h, &$handler, &$r, $d) {
	{
		$_g->_changed($file, "loaded", $d, $r);
		sirius_Sirius::$resources->register($file, $d);
		if($handler !== null) {
			call_user_func_array($handler, array(new sirius_net_Request(true, $d, null, $file)));
		}
	}
}
function sirius_net_Loader_3(&$_g, &$data, &$file, &$h, &$handler, &$r, $d1) {
	{
		$_g->_changed($file, "error", $d1, $r);
		if($handler !== null) {
			call_user_func_array($handler, array(new sirius_net_Request(false, null, new sirius_errors_Error(-1, $d1, null), $file)));
		}
	}
}
function sirius_net_Loader_4(&$_g, &$data, &$handler, &$headers, &$is_data, &$is_get, &$is_post, &$method, &$r, &$url, $p, $v) {
	{
		$r->setHeader($p, $v);
	}
}
function sirius_net_Loader_5(&$_g, &$data, &$handler, &$headers, &$is_data, &$is_get, &$is_post, &$method, &$r, &$url, $d) {
	{
		if($handler !== null) {
			$_g->_changed($url, "loaded", $d, $r);
			call_user_func_array($handler, array(new sirius_net_Request(true, $d, null, null)));
		}
	}
}
function sirius_net_Loader_6(&$_g, &$data, &$handler, &$headers, &$is_data, &$is_get, &$is_post, &$method, &$r, &$url, $d1) {
	{
		$_g->_changed($url, "error", $d1, $r);
		if($handler !== null) {
			call_user_func_array($handler, array(new sirius_net_Request(false, null, new sirius_errors_Error(-1, $d1, null), null)));
		}
	}
}
