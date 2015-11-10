<?php

class sirius_db_tools_QueryBuilder implements sirius_db_tools_IQueryBuilder{
	public function __construct($gate) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_gate = $gate;
		$GLOBALS['%s']->pop();
	}}
	public $_gate;
	public function _conditions($obj, $props, $joiner) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_conditions");
		$__hx__spos = $GLOBALS['%s']->length;
		$_g = $this;
		$r = (new _hx_array(array()));
		$s = $joiner;
		$b = true;
		if(Std::is($obj, _hx_qtype("sirius.db.Clause"))) {
			sirius_utils_Dice::Values($obj->conditions, array(new _hx_lambda(array(&$_g, &$b, &$joiner, &$obj, &$props, &$r, &$s), "sirius_db_tools_QueryBuilder_0"), 'execute'), null);
			$s = $obj->joiner();
		} else {
			if(Std::is($obj, _hx_qtype("Array"))) {
				sirius_utils_Dice::All($obj, array(new _hx_lambda(array(&$_g, &$b, &$joiner, &$obj, &$props, &$r, &$s), "sirius_db_tools_QueryBuilder_1"), 'execute'), null);
			} else {
				$r[$r->length] = sirius_utils_Filler::to($obj->condition, _hx_anonymous(array("p" => $obj->param)), null);
				$props->{"in_" . Std::string($obj->param)} = $obj->value;
			}
		}
		$b = $r->length > 1;
		{
			$tmp = _hx_string_or_null(((($b) ? "(" : ""))) . _hx_string_or_null($r->join($s)) . _hx_string_or_null(((($b) ? ")" : "")));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function _assembleBody($clause = null, $parameters = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_assembleBody");
		$__hx__spos = $GLOBALS['%s']->length;
		$q = "";
		if($clause !== null) {
			$q .= " WHERE " . _hx_string_or_null($this->_conditions($clause, $parameters, " || "));
		}
		if($order !== null) {
			$q .= " ORDER BY " . _hx_string_or_null($this->_order($order));
		}
		if($limit !== null) {
			$q .= " LIMIT " . _hx_string_or_null($limit);
		}
		{
			$GLOBALS['%s']->pop();
			return $q;
		}
		$GLOBALS['%s']->pop();
	}
	public function create($table, $clause = null, $parameters = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::create");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_gate->prepare("INSERT INTO " . _hx_string_or_null($table) . _hx_string_or_null($this->_assembleBody($clause, $parameters, $order, $limit)) . ";", $parameters, null);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function find($fields, $table, $clause = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::find");
		$__hx__spos = $GLOBALS['%s']->length;
		if(Std::is($fields, _hx_qtype("Array"))) {
			$fields = $fields->join(",");
		}
		$parameters = _hx_anonymous(array());
		{
			$tmp = $this->_gate->prepare("SELECT " . Std::string($fields) . " FROM " . _hx_string_or_null($table) . _hx_string_or_null($this->_assembleBody($clause, $parameters, $order, $limit)) . ";", $parameters, null);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function update($table, $clause = null, $parameters = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::update");
		$__hx__spos = $GLOBALS['%s']->length;
		if($parameters === null) {
			$parameters = _hx_anonymous(array());
		}
		{
			$tmp = $this->_gate->prepare("UPDATE " . _hx_string_or_null($table) . " " . _hx_string_or_null($this->_updateSet($parameters)) . _hx_string_or_null($this->_assembleBody($clause, $parameters, $order, $limit)) . ";", $parameters, null);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function delete($table, $clause = null, $order = null, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::delete");
		$__hx__spos = $GLOBALS['%s']->length;
		$parameters = _hx_anonymous(array());
		{
			$tmp = $this->_gate->prepare("DELETE FROM " . _hx_string_or_null($table) . _hx_string_or_null($this->_assembleBody($clause, $parameters, $order, $limit)) . ";", $parameters, null);
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function _insert($parameters) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_insert");
		$__hx__spos = $GLOBALS['%s']->length;
		$q = (new _hx_array(array()));
		sirius_utils_Dice::Params($parameters, array(new _hx_lambda(array(&$parameters, &$q), "sirius_db_tools_QueryBuilder_2"), 'execute'), null);
		{
			$tmp = "(" . _hx_string_or_null($q->join(",")) . ") VALUES (:" . _hx_string_or_null($q->join(",:")) . ")";
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function _updateSet($parameters) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_updateSet");
		$__hx__spos = $GLOBALS['%s']->length;
		$q = (new _hx_array(array()));
		sirius_utils_Dice::Params($parameters, array(new _hx_lambda(array(&$parameters, &$q), "sirius_db_tools_QueryBuilder_3"), 'execute'), null);
		{
			$tmp = $q->join(",");
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function _order($obj) {
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_order");
		$__hx__spos = $GLOBALS['%s']->length;
		$r = (new _hx_array(array()));
		sirius_utils_Dice::All($obj, array(new _hx_lambda(array(&$obj, &$r), "sirius_db_tools_QueryBuilder_4"), 'execute'), null);
		{
			$tmp = $r->join(",");
			$GLOBALS['%s']->pop();
			return $tmp;
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
	function __toString() { return 'sirius.db.tools.QueryBuilder'; }
}
function sirius_db_tools_QueryBuilder_0(&$_g, &$b, &$joiner, &$obj, &$props, &$r, &$s, $v) {
	{
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_conditions@27");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$r[$r->length] = $_g->_conditions($v, $props, $joiner);
		$GLOBALS['%s']->pop();
	}
}
function sirius_db_tools_QueryBuilder_1(&$_g, &$b, &$joiner, &$obj, &$props, &$r, &$s, $p, $v1) {
	{
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_conditions@32");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if(Std::is($v1, _hx_qtype("sirius.db.Clause"))) {
			$r[$r->length] = $_g->_conditions($v1, $props, $v1->joiner());
		} else {
			$r[$r->length] = $_g->_conditions($v1, $props, $joiner);
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_db_tools_QueryBuilder_2(&$parameters, &$q, $p) {
	{
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_insert@85");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$q[$q->length] = $p;
		$GLOBALS['%s']->pop();
	}
}
function sirius_db_tools_QueryBuilder_3(&$parameters, &$q, $p) {
	{
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_updateSet@92");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$q[$q->length] = _hx_string_or_null($p) . "=:" . _hx_string_or_null($p);
		$GLOBALS['%s']->pop();
	}
}
function sirius_db_tools_QueryBuilder_4(&$obj, &$r, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.db.tools.QueryBuilder::_order@99");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$r[$r->length] = _hx_string_or_null($p) . _hx_string_or_null((sirius_db_tools_QueryBuilder_5($__hx__this, $obj, $p, $r, $v)));
		$GLOBALS['%s']->pop();
	}
}
function sirius_db_tools_QueryBuilder_5(&$__hx__this, &$obj, &$p, &$r, &$v) {
	if($v !== null) {
		return " " . Std::string($v);
	} else {
		return "";
	}
}
