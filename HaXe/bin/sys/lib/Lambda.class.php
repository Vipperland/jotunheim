<?php

class Lambda {
	public function __construct(){}
	static function harray($it) {
		$a = new _hx_array(array());
		if(null == $it) throw new HException('null iterable');
		$__hx__it = $it->iterator();
		while($__hx__it->hasNext()) {
			unset($i);
			$i = $__hx__it->next();
			$a->push($i);
		}
		return $a;
	}
	static function indexOf($it, $v) {
		$i = 0;
		if(null == $it) throw new HException('null iterable');
		$__hx__it = $it->iterator();
		while($__hx__it->hasNext()) {
			unset($v2);
			$v2 = $__hx__it->next();
			if((is_object($_t = $v) && !($_t instanceof Enum) ? $_t === $v2 : $_t == $v2)) {
				return $i;
			}
			$i++;
			unset($_t);
		}
		return -1;
	}
	function __toString() { return 'Lambda'; }
}
