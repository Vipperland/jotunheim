<?php

class sirius_php_file_FileCollection {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->named = _hx_anonymous(array());
		$this->{"list"} = (new _hx_array(array()));
		$this->{"list"} = (new _hx_array(array()));
		$this->named = (new _hx_array(array()));
	}}
	public $list;
	public $named;
	public function add($part, $file) {
		$this->{"list"}[$this->{"list"}->length] = $file;
		if($part !== null) {
			$this->named->{$part} = $file;
		}
	}
	public function getByName($name) {
		return Reflect::field($this->named, $name);
	}
	public function getByIndex($index) {
		if(sirius_php_file_FileCollection_0($this, $index)) {
			return $this->{"list"}[$index];
		} else {
			return null;
		}
	}
	public function getFileNames() {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::Values($this->{"list"}, array(new _hx_lambda(array(&$r), "sirius_php_file_FileCollection_1"), 'execute'), null);
		return $r;
	}
	public function getByType($type = null) {
		if($type === null) {
			$type = "*";
		}
		$r = null;
		if($type === "*") {
			$r = _hx_anonymous(array());
		} else {
			$r = (new _hx_array(array()));
		}
		sirius_utils_Dice::Values($this->{"list"}, array(new _hx_lambda(array(&$r, &$type), "sirius_php_file_FileCollection_2"), 'execute'), null);
		return $r;
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
	function __toString() { return 'sirius.php.file.FileCollection'; }
}
function sirius_php_file_FileCollection_0(&$__hx__this, &$index) {
	{
		$a = $__hx__this->{"list"}->length;
		$aNeg = $a < 0;
		$bNeg = $index < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return $a > $index;
		}
		unset($bNeg,$aNeg,$a);
	}
}
function sirius_php_file_FileCollection_1(&$r, $v) {
	{
		if($v->type === "image") {
			$r[$r->length] = $v->output;
		}
	}
}
function sirius_php_file_FileCollection_2(&$r, &$type, $v) {
	{
		if($type === "*") {
			if($v->type === $type) {
				$r[_hx_len($r)] = $v;
			}
		} else {
			if(!_hx_has_field($r, $v->type)) {
				$r->{$v->type} = (new _hx_array(array()));
			}
			Reflect::field($r, $v->type)->push($v);
		}
	}
}
