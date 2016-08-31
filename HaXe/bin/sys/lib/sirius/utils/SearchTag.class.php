<?php

class sirius_utils_SearchTag {
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
		$_g = $this;
		if(Std::is($values, _hx_qtype("Array"))) {
			$values = $values;
		} else {
			$values = (new _hx_array(array($values)));
		}
		sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$_g, &$values), "sirius_utils_SearchTag_0"), 'execute'), null);
	}
	public function remove($values) {
		$_g = $this;
		$values = sirius_utils_SearchTag::from($values)->tags;
		sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$_g, &$values), "sirius_utils_SearchTag_1"), 'execute'), null);
	}
	public function compare($values, $equality = null) {
		if($equality === null) {
			$equality = false;
		}
		$tag = $this->_tag();
		$values = sirius_utils_SearchTag::from($values)->tags;
		$total = _hx_len($values);
		$count = sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$equality, &$tag, &$total, &$values), "sirius_utils_SearchTag_2"), 'execute'), null)->keys;
		return sirius_utils_SearchTag_3($this, $count, $equality, $tag, $total, $values) / sirius_utils_SearchTag_4($this, $count, $equality, $tag, $total, $values) * 100;
	}
	public function equal($values) {
		$tag = $this->_tag();
		$values = sirius_utils_SearchTag::from($values)->tags;
		return sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$tag, &$values), "sirius_utils_SearchTag_5"), 'execute'), null)->completed;
	}
	public function contains($values) {
		$tag = $this->_tag();
		$values = sirius_utils_SearchTag::from($values)->tags;
		return !sirius_utils_Dice::Values($values, array(new _hx_lambda(array(&$tag, &$values), "sirius_utils_SearchTag_6"), 'execute'), null)->completed;
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
		if(!Std::is($value, _hx_qtype("sirius.utils.SearchTag"))) {
			$value = new sirius_utils_SearchTag($value);
		}
		return $value;
	}
	static function convert($data) {
		$data = _hx_explode(" ", strtolower(Std::string($data)))->join("");
		$data = sirius_utils_SearchTag::$_E->replace($data, "");
		$i = 0;
		$l = _hx_len(sirius_utils_SearchTag::$_M);
		while($i < $l) {
			$data = _hx_string_call($data, "split", array(sirius_utils_SearchTag::$_M[$i][0]))->join(sirius_utils_SearchTag::$_M[$i][1]);
			++$i;
		}
		return $data;
	}
	function __toString() { return 'sirius.utils.SearchTag'; }
}
sirius_utils_SearchTag::$_M = (new _hx_array(array((new _hx_array(array("á", "a"))), (new _hx_array(array("ã", "a"))), (new _hx_array(array("â", "a"))), (new _hx_array(array("à", "a"))), (new _hx_array(array("ê", "e"))), (new _hx_array(array("é", "e"))), (new _hx_array(array("è", "e"))), (new _hx_array(array("î", "i"))), (new _hx_array(array("í", "i"))), (new _hx_array(array("ì", "i"))), (new _hx_array(array("õ", "o"))), (new _hx_array(array("ô", "o"))), (new _hx_array(array("ó", "o"))), (new _hx_array(array("ò", "o"))), (new _hx_array(array("ú", "u"))), (new _hx_array(array("ù", "u"))), (new _hx_array(array("û", "u"))), (new _hx_array(array("ç", "c"))))));
sirius_utils_SearchTag::$_E = new EReg("^[a-zA-Z0-9- ]", "g");
function sirius_utils_SearchTag_0(&$_g, &$values, $v) {
	{
		$v = sirius_utils_SearchTag::convert($v);
		$iof = Lambda::indexOf($_g->tags, $v);
		if($iof === -1) {
			$_g->tags[$_g->tags->length] = $v;
		}
	}
}
function sirius_utils_SearchTag_1(&$_g, &$values, $v) {
	{
		$iof = Lambda::indexOf($_g->tags, $v);
		if($iof !== -1) {
			$_g->tags->splice($iof, 1);
		}
	}
}
function sirius_utils_SearchTag_2(&$equality, &$tag, &$total, &$values, $v) {
	{
		if($equality) {
			return _hx_index_of($tag, "|" . _hx_string_or_null($v) . "|", null) === -1;
		} else {
			return _hx_index_of($tag, $v, null) !== -1;
		}
	}
}
function sirius_utils_SearchTag_3(&$__hx__this, &$count, &$equality, &$tag, &$total, &$values) {
	{
		$int = $count;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_utils_SearchTag_4(&$__hx__this, &$count, &$equality, &$tag, &$total, &$values) {
	{
		$int1 = $total;
		if($int1 < 0) {
			return 4294967296.0 + $int1;
		} else {
			return $int1 + 0.0;
		}
		unset($int1);
	}
}
function sirius_utils_SearchTag_5(&$tag, &$values, $v) {
	{
		return _hx_index_of($tag, "|" . _hx_string_or_null($v) . "|", null) === -1;
	}
}
function sirius_utils_SearchTag_6(&$tag, &$values, $v) {
	{
		return _hx_index_of($tag, $v, null) !== -1;
	}
}
