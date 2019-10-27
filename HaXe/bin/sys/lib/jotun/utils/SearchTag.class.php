<?php

// Generated by Haxe 3.4.7
class jotun_utils_SearchTag {
	public function __construct($tags = null) {
		if(!php_Boot::$skip_constructor) {
		$tags = (new _hx_array(array()));
		$this->add($tags);
	}}
	public $tags;
	public function _tag() {
		return "|" . _hx_string_or_null($this->tags->join("|")) . "|";
	}
	public function add($values) {
		$_gthis = $this;
		if(Std::is($values, _hx_qtype("Array"))) {
			$values = $values;
		} else {
			$values = (new _hx_array(array($values)));
		}
		jotun_utils_Dice::Values($values, array(new _hx_lambda(array(&$_gthis), "jotun_utils_SearchTag_0"), 'execute'), null);
	}
	public function remove($values) {
		$_gthis = $this;
		$values = jotun_utils_SearchTag::from($values)->tags;
		jotun_utils_Dice::Values($values, array(new _hx_lambda(array(&$_gthis), "jotun_utils_SearchTag_1"), 'execute'), null);
	}
	public function compare($values, $equality = null) {
		if($equality === null) {
			$equality = false;
		}
		$tag = $this->_tag();
		$values = jotun_utils_SearchTag::from($values)->tags;
		$total = _hx_field($values, "length");
		$count = jotun_utils_Dice::Values($values, array(new _hx_lambda(array(&$equality, &$tag), "jotun_utils_SearchTag_2"), 'execute'), null)->keys;
		$int = $count;
		$tmp = null;
		if($int < 0) {
			$tmp = 4294967296.0 + $int;
		} else {
			$tmp = $int + 0.0;
		}
		$int1 = $total;
		$tmp1 = null;
		if($int1 < 0) {
			$tmp1 = 4294967296.0 + $int1;
		} else {
			$tmp1 = $int1 + 0.0;
		}
		return $tmp / $tmp1 * 100;
	}
	public function equal($values) {
		$tag = $this->_tag();
		$values = jotun_utils_SearchTag::from($values)->tags;
		return jotun_utils_Dice::Values($values, array(new _hx_lambda(array(&$tag), "jotun_utils_SearchTag_3"), 'execute'), null)->completed;
	}
	public function contains($values) {
		$tag = $this->_tag();
		$values = jotun_utils_SearchTag::from($values)->tags;
		return !jotun_utils_Dice::Values($values, array(new _hx_lambda(array(&$tag), "jotun_utils_SearchTag_4"), 'execute'), null)->completed;
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
	static function _M() { $args = func_get_args(); return call_user_func_array(self::$_M, $args); }
	static $_M;
	static $_E;
	static function from($value) {
		if(!Std::is($value, _hx_qtype("jotun.utils.SearchTag"))) {
			$value = new jotun_utils_SearchTag($value);
		}
		return $value;
	}
	static function convert($data) {
		$data = _hx_explode(" ", strtolower(Std::string($data)))->join("");
		$data1 = Std::string(_hx_string_call($data, "substr", array(0, 1)));
		$data = _hx_string_or_null($data1) . _hx_string_or_null(jotun_utils_SearchTag::$_E->replace($data, ""));
		return $data;
	}
	function __toString() { return 'jotun.utils.SearchTag'; }
}
jotun_utils_SearchTag::$_M = (new _hx_array(array((new _hx_array(array("á", "a"))), (new _hx_array(array("ã", "a"))), (new _hx_array(array("â", "a"))), (new _hx_array(array("à", "a"))), (new _hx_array(array("ê", "e"))), (new _hx_array(array("é", "e"))), (new _hx_array(array("è", "e"))), (new _hx_array(array("î", "i"))), (new _hx_array(array("í", "i"))), (new _hx_array(array("ì", "i"))), (new _hx_array(array("õ", "o"))), (new _hx_array(array("ô", "o"))), (new _hx_array(array("ó", "o"))), (new _hx_array(array("ò", "o"))), (new _hx_array(array("ú", "u"))), (new _hx_array(array("ù", "u"))), (new _hx_array(array("û", "u"))), (new _hx_array(array("ç", "c"))))));
jotun_utils_SearchTag::$_E = new EReg("^[a-z0-9]", "g");
function jotun_utils_SearchTag_0(&$_gthis, $v) {
	{
		$v = jotun_utils_SearchTag::convert($v);
		$iof = Lambda::indexOf($_gthis->tags, $v);
		if($iof === -1) {
			$_gthis->tags[$_gthis->tags->length] = $v;
		}
	}
}
function jotun_utils_SearchTag_1(&$_gthis, $v) {
	{
		$iof = Lambda::indexOf($_gthis->tags, $v);
		if($iof !== -1) {
			$_gthis->tags->splice($iof, 1);
		}
	}
}
function jotun_utils_SearchTag_2(&$equality, &$tag, $v) {
	{
		if($equality) {
			return _hx_index_of($tag, "|" . _hx_string_or_null($v) . "|", null) === -1;
		} else {
			return _hx_index_of($tag, $v, null) !== -1;
		}
	}
}
function jotun_utils_SearchTag_3(&$tag, $v) {
	{
		return _hx_index_of($tag, "|" . _hx_string_or_null($v) . "|", null) === -1;
	}
}
function jotun_utils_SearchTag_4(&$tag, $v) {
	{
		return _hx_index_of($tag, $v, null) !== -1;
	}
}