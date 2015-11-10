<?php

class sirius_data_Fragments implements sirius_data_IFragments{
	public function __construct($value, $separator = null) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.data.Fragments::new");
		$__hx__spos = $GLOBALS['%s']->length;
		if($value === null) {
			$this->value = "";
		} else {
			$this->value = $value;
		}
		if($separator !== null && strlen($separator) > 0) {
			$this->split($separator);
		} else {
			$this->clear();
		}
		$GLOBALS['%s']->pop();
	}}
	public $value;
	public $pieces;
	public $first;
	public $last;
	public function split($separator) {
		$GLOBALS['%s']->push("sirius.data.Fragments::split");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->pieces = sirius_tools_Utils::clearArray(_hx_explode($separator, $this->value), null);
		if($this->pieces->length === 0) {
			$this->pieces[0] = "";
		}
		$this->first = $this->pieces[0];
		$this->last = $this->pieces[$this->pieces->length - 1];
		$this->glue($this->value);
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function find($value) {
		$GLOBALS['%s']->push("sirius.data.Fragments::find");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = Lambda::indexOf($this->pieces, $value) !== -1;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function glue($value) {
		$GLOBALS['%s']->push("sirius.data.Fragments::glue");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->value = $this->pieces->join($value);
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function addPiece($value, $at = null) {
		$GLOBALS['%s']->push("sirius.data.Fragments::addPiece");
		$__hx__spos = $GLOBALS['%s']->length;
		if($at === null) {
			$at = -1;
		}
		if($at === 0) {
			$this->pieces->unshift($value);
		} else {
			if($at === -1 || $at >= $this->pieces->length) {
				$this->pieces->push($value);
			} else {
				$tail = $this->pieces->splice($at, $this->pieces->length - $at);
				$this->pieces->push($value);
				$this->pieces = $this->pieces->concat($tail);
			}
		}
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function get($i) {
		$GLOBALS['%s']->push("sirius.data.Fragments::get");
		$__hx__spos = $GLOBALS['%s']->length;
		if($i < $this->pieces->length) {
			$tmp = $this->pieces[$i];
			$GLOBALS['%s']->pop();
			return $tmp;
		} else {
			$GLOBALS['%s']->pop();
			return "";
		}
		$GLOBALS['%s']->pop();
	}
	public function clear() {
		$GLOBALS['%s']->push("sirius.data.Fragments::clear");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->pieces = (new _hx_array(array()));
		$this->first = "";
		$this->last = "";
		{
			$GLOBALS['%s']->pop();
			return $this;
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
	function __toString() { return 'sirius.data.Fragments'; }
}
