<?php

class sirius_data_Fragments implements sirius_data_IFragments{
	public function __construct($value, $separator = null) {
		if(!php_Boot::$skip_constructor) {
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
	}}
	public $value;
	public $pieces;
	public $first;
	public $last;
	public function _sel($i, $e) {
		$r = (new _hx_array(array()));
		while($i !== $e) {
			$r[$r->length] = $this->pieces[$i++];
		}
		return "/" . _hx_string_or_null($r->join("/")) . "/";
	}
	public function split($separator) {
		$this->pieces = sirius_tools_Utils::clearArray(_hx_explode($separator, $this->value), null);
		if($this->pieces->length === 0) {
			$this->pieces[0] = "";
		}
		$this->first = $this->pieces[0];
		$this->last = $this->pieces[$this->pieces->length - 1];
		$this->glue($separator);
		return $this;
	}
	public function find($value) {
		return Lambda::indexOf($this->pieces, $value) !== -1;
	}
	public function glue($value) {
		$this->value = $this->pieces->join($value);
		return $this;
	}
	public function addPiece($value, $at = null) {
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
		return $this;
	}
	public function get($i, $e = null) {
		if($e === null || $e <= $i) {
			if($i < $this->pieces->length) {
				return $this->pieces[$i];
			} else {
				return "";
			}
		} else {
			return $this->_sel($i, $e);
		}
	}
	public function set($i, $val) {
		if($i > $this->pieces->length) {
			$i = $this->pieces->length;
		}
		if($val !== null) {
			$this->pieces[$i] = $val;
		}
		return $this;
	}
	public function clear() {
		$this->pieces = (new _hx_array(array()));
		$this->first = "";
		$this->last = "";
		return $this;
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
