<?php

class sirius_php_file_FileInfo {
	public function __construct($type, $input, $output) {
		if(!php_Boot::$skip_constructor) {
		$this->type = $type;
		$this->output = $output;
		$this->input = $input;
	}}
	public $type;
	public $input;
	public $output;
	public $sizes;
	public $error;
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
	function __toString() { return 'sirius.php.file.FileInfo'; }
}
