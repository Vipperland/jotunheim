<?php

class sirius_php_data_Cache {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.php.data.Cache::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$GLOBALS['%s']->pop();
	}}
	public function set($name, $value) {
		$GLOBALS['%s']->push("sirius.php.data.Cache::set");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->{$name} = $value;
		$GLOBALS['%s']->pop();
	}
	public function add($name, $value) {
		$GLOBALS['%s']->push("sirius.php.data.Cache::add");
		$__hx__spos = $GLOBALS['%s']->length;
		if($this->hasField($name)) {
			$value1 = $this->get($name)->concat($value);
			$this->{$name} = $value1;
		} else {
			$this->{$name} = $value;
		}
		$GLOBALS['%s']->pop();
	}
	public function get($name) {
		$GLOBALS['%s']->push("sirius.php.data.Cache::get");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = Reflect::field($this, $name);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function hasField($name) {
		$GLOBALS['%s']->push("sirius.php.data.Cache::hasField");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = _hx_has_field($this, $name);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function json($print = null, $encoding = null) {
		$GLOBALS['%s']->push("sirius.php.data.Cache::json");
		$__hx__spos = $GLOBALS['%s']->length;
		if($print === null) {
			$print = true;
		}
		$result = json_encode($this,256);
		if($encoding !== null) {
			$result = call_user_func_array($encoding, array($result));
		}
		if($print) {
			php_Lib::hprint($result);
		}
		{
			$GLOBALS['%s']->pop();
			return $result;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.php.data.Cache'; }
}
