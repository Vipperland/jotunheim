<?php

class sys_net_Socket {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sys.net.Socket::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->input = new sys_io_FileInput(null);
		$this->output = new sys_io_FileOutput(null);
		$this->protocol = "tcp";
		$GLOBALS['%s']->pop();
	}}
	public $__s;
	public $protocol;
	public $input;
	public $output;
	public function assignHandler() {
		$GLOBALS['%s']->push("sys.net.Socket::assignHandler");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->input->__f = $this->__s;
		$this->output->__f = $this->__s;
		$GLOBALS['%s']->pop();
	}
	public function close() {
		$GLOBALS['%s']->push("sys.net.Socket::close");
		$__hx__spos = $GLOBALS['%s']->length;
		fclose($this->__s);
		{
			$this->input->__f = null;
			$this->output->__f = null;
		}
		$this->input->close();
		$this->output->close();
		$GLOBALS['%s']->pop();
	}
	public function write($content) {
		$GLOBALS['%s']->push("sys.net.Socket::write");
		$__hx__spos = $GLOBALS['%s']->length;
		fwrite($this->__s, $content);
		{
			$GLOBALS['%s']->pop();
			return;
		}
		$GLOBALS['%s']->pop();
	}
	public function connect($host, $port) {
		$GLOBALS['%s']->push("sys.net.Socket::connect");
		$__hx__spos = $GLOBALS['%s']->length;
		$errs = null;
		$errn = null;
		$r = stream_socket_client(_hx_string_or_null($this->protocol) . "://" . _hx_string_or_null($host->_ip) . ":" . _hx_string_rec($port, ""), $errn, $errs);
		sys_net_Socket::checkError($r, $errn, $errs);
		$this->__s = $r;
		$this->assignHandler();
		$GLOBALS['%s']->pop();
	}
	public function shutdown($read, $write) {
		$GLOBALS['%s']->push("sys.net.Socket::shutdown");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = null;
		if(function_exists("stream_socket_shutdown")) {
			$rw = null;
			if($read && $write) {
				$rw = 2;
			} else {
				if($write) {
					$rw = 1;
				} else {
					if($read) {
						$rw = 0;
					} else {
						$rw = 2;
					}
				}
			}
			$r = stream_socket_shutdown($this->__s, $rw);
		} else {
			$r = fclose($this->__s);
		}
		sys_net_Socket::checkError($r, 0, "Unable to Shutdown");
		$GLOBALS['%s']->pop();
	}
	public function setTimeout($timeout) {
		$GLOBALS['%s']->push("sys.net.Socket::setTimeout");
		$__hx__spos = $GLOBALS['%s']->length;
		$s = Std::int($timeout);
		$ms = Std::int(($timeout - $s) * 1000000);
		$r = stream_set_timeout($this->__s, $s, $ms);
		sys_net_Socket::checkError($r, 0, "Unable to set timeout");
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
	static function checkError($r, $code, $msg) {
		$GLOBALS['%s']->push("sys.net.Socket::checkError");
		$__hx__spos = $GLOBALS['%s']->length;
		if(!($r === false)) {
			$GLOBALS['%s']->pop();
			return;
		}
		throw new HException(haxe_io_Error::Custom("Error [" . _hx_string_rec($code, "") . "]: " . _hx_string_or_null($msg)));
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sys.net.Socket'; }
}
