<?php

class sirius_db_QueryBuilder {
	public function __construct() {}
	public function _clausule($obj) { if(!php_Boot::$skip_constructor) {
		$_g = $this;
		$r = (new _hx_array(array()));
		$s = " && ";
		$b = true;
		if(Std::is($obj, _hx_qtype("Array"))) {
			sirius_utils_Dice::Values($obj, array(new _hx_lambda(array(&$_g, &$b, &$obj, &$r, &$s), "sirius_db_QueryBuilder_0"), 'execute'), null);
			$s = " || ";
		} else {
			sirius_utils_Dice::All($obj, array(new _hx_lambda(array(&$_g, &$b, &$obj, &$r, &$s), "sirius_db_QueryBuilder_1"), 'execute'), null);
		}
		$b = $r->length > 1;
		return _hx_string_or_null(((($b) ? "(" : ""))) . _hx_string_or_null($r->join($s)) . _hx_string_or_null(((($b) ? ")" : "")));
	}}
	public function select($fields, $table, $conditions = null, $properties = null, $order = null, $limit = null) {
		if(Std::is($fields, _hx_qtype("Array"))) {
			$fields = $fields->join(",");
		}
		$q = "SELECT " . Std::string($fields) . " FROM " . _hx_string_or_null($table);
		if($conditions !== null) {
			$q .= " WHERE " . _hx_string_or_null($this->_clausule($conditions));
		}
		if($order !== null) {
			$q .= " ORDER BY " . _hx_string_or_null($this->_order($order));
		}
		if($limit !== null) {
			$q .= " LIMIT " . _hx_string_or_null($limit);
		}
		return _hx_string_or_null($q) . ";";
	}
	public function _order($obj) {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::All($obj, array(new _hx_lambda(array(&$obj, &$r), "sirius_db_QueryBuilder_2"), 'execute'), null);
		return $r->join(",");
	}
	function __toString() { return 'sirius.db.QueryBuilder'; }
}
function sirius_db_QueryBuilder_0(&$_g, &$b, &$obj, &$r, &$s, $v) {
	{
		$r[$r->length] = $_g->_clausule($v);
	}
}
function sirius_db_QueryBuilder_1(&$_g, &$b, &$obj, &$r, &$s, $p, $v1) {
	{
		$r[$r->length] = _hx_string_or_null($p) . _hx_string_or_null(((($v1 === null) ? "=" : $v1))) . ":" . _hx_string_or_null($p);
	}
}
function sirius_db_QueryBuilder_2(&$obj, &$r, $p, $v) {
	{
		$r[$r->length] = _hx_string_or_null($p) . _hx_string_or_null((sirius_db_QueryBuilder_3($__hx__this, $obj, $p, $r, $v)));
	}
}
function sirius_db_QueryBuilder_3(&$__hx__this, &$obj, &$p, &$r, &$v) {
	if($v !== null) {
		return " " . Std::string($v);
	} else {
		return "";
	}
}
