<?php

class sirius_php_file_ImageLib {
	public function __construct($files) {
		if(!php_Boot::$skip_constructor) {
		$this->content = (new _hx_array(array()));
		if($files !== null) {
			$this->open($files);
		}
	}}
	public $content;
	public function open($files) {
		$_g = $this;
		if(!Std::is($files, _hx_qtype("Array"))) {
			$files = (new _hx_array(array($files)));
		}
		sirius_utils_Dice::Values($files, array(new _hx_lambda(array(&$_g, &$files), "sirius_php_file_ImageLib_0"), 'execute'), null);
		return $this;
	}
	public function resample($width, $height, $ratio = null) {
		if($ratio === null) {
			$ratio = true;
		}
		sirius_utils_Dice::Values($this->content, array(new _hx_lambda(array(&$height, &$ratio, &$width), "sirius_php_file_ImageLib_1"), 'execute'), null);
		return $this;
	}
	public function crop($x, $y, $width, $height) {
		sirius_utils_Dice::Values($this->content, array(new _hx_lambda(array(&$height, &$width, &$x, &$y), "sirius_php_file_ImageLib_2"), 'execute'), null);
		return $this;
	}
	public function fit($width, $height) {
		sirius_utils_Dice::Values($this->content, array(new _hx_lambda(array(&$height, &$width), "sirius_php_file_ImageLib_3"), 'execute'), null);
		return $this;
	}
	public function save($type = null) {
		sirius_utils_Dice::Values($this->content, array(new _hx_lambda(array(&$type), "sirius_php_file_ImageLib_4"), 'execute'), null);
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
	function __toString() { return 'sirius.php.file.ImageLib'; }
}
function sirius_php_file_ImageLib_0(&$_g, &$files, $v) {
	{
		$img = new sirius_php_file_Image($v);
		if($img->isValid()) {
			$_g->content[$_g->content->length] = $img;
		}
	}
}
function sirius_php_file_ImageLib_1(&$height, &$ratio, &$width, $v) {
	{
		$v->resample($width, $height, $ratio);
	}
}
function sirius_php_file_ImageLib_2(&$height, &$width, &$x, &$y, $v) {
	{
		$v->crop($x, $y, $width, $height);
	}
}
function sirius_php_file_ImageLib_3(&$height, &$width, $v) {
	{
		$v->fit($width, $height, null);
	}
}
function sirius_php_file_ImageLib_4(&$type, $v) {
	{
		$v->save(null, $type);
	}
}
