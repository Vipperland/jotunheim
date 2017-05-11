<?php

class sirius_math_Point implements sirius_math_IPoint{
	public function __construct($x, $y) {
		if(!php_Boot::$skip_constructor) {
		$this->x = $x;
		$this->y = $y;
	}}
	public $x;
	public $y;
	public function reset() {
		$this->x = $this->y = 0;
	}
	public function match($o, $round = null) {
		if($round) {
			return Math::round($o->x) === Math::round($this->x) && Math::round($o->y) === Math::round($this->y);
		} else {
			return $o->x === $this->x && $o->y === $this->y;
		}
	}
	public function add($q) {
		$this->x += $q->x;
		$this->y += $q->y;
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
	function __toString() { return 'sirius.math.Point'; }
}
