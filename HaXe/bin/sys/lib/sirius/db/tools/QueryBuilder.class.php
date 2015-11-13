<?php

class sirius_db_tools_QueryBuilder implements sirius_db_tools_IQueryBuilder{
	public function __construct($gate) {
		if(!php_Boot::$skip_constructor) {
		$this->_gate = $gate;
	}}
	public $_gate;
	public function _conditions($obj, $props, $joiner) {
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
		return _hx_string_or_null(((($b) ? "(" : ""))) . _hx_string_or_null($r->join($s)) . _hx_string_or_null(((($b) ? ")" : "")));
	}
	public function _assembleBody($clause = null, $parameters = null, $order = null, $limit = null) {
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
		return $q;
	}
	public function add($table, $clause = null, $parameters = null, $order = null, $limit = null) {
		return $this->_gate->prepare("INSERT INTO " . _hx_string_or_null($table) . _hx_string_or_null($this->_insert($parameters)) . _hx_string_or_null($this->_assembleBody($clause, $parameters, $order, $limit)) . ";", $parameters, null);
	}
	public function find($fields, $table, $clause = null, $order = null, $limit = null) {
		if(Std::is($fields, _hx_qtype("Array"))) {
			$fields = $fields->join(",");
		}
		$parameters = _hx_anonymous(array());
		return $this->_gate->prepare("SELECT " . Std::string($fields) . " FROM " . _hx_string_or_null($table) . _hx_string_or_null($this->_assembleBody($clause, $parameters, $order, $limit)) . ";", $parameters, null);
	}
	public function update($table, $clause = null, $parameters = null, $order = null, $limit = null) {
		if($parameters === null) {
			$parameters = _hx_anonymous(array());
		}
		return $this->_gate->prepare("UPDATE " . _hx_string_or_null($table) . " SET " . _hx_string_or_null($this->_updateSet($parameters)) . _hx_string_or_null($this->_assembleBody($clause, $parameters, $order, $limit)) . ";", $parameters, null);
	}
	public function delete($table, $clause = null, $order = null, $limit = null) {
		$parameters = _hx_anonymous(array());
		return $this->_gate->prepare("DELETE FROM " . _hx_string_or_null($table) . _hx_string_or_null($this->_assembleBody($clause, $parameters, $order, $limit)) . ";", $parameters, null);
	}
	public function copy($from, $to, $clause = null, $parameters = null, $limit = null) {
		$_g = $this;
		$entries = $this->find("*", $from, $clause, null, $limit)->result;
		sirius_utils_Dice::Values($entries, array(new _hx_lambda(array(&$_g, &$clause, &$entries, &$from, &$limit, &$parameters, &$to), "sirius_db_tools_QueryBuilder_2"), 'execute'), null);
		return null;
	}
	public function _insert($parameters) {
		$q = (new _hx_array(array()));
		sirius_utils_Dice::Params($parameters, array(new _hx_lambda(array(&$parameters, &$q), "sirius_db_tools_QueryBuilder_3"), 'execute'), null);
		return "(" . _hx_string_or_null($q->join(",")) . ") VALUES (:" . _hx_string_or_null($q->join(",:")) . ")";
	}
	public function _updateSet($parameters) {
		$q = (new _hx_array(array()));
		sirius_utils_Dice::All($parameters, array(new _hx_lambda(array(&$parameters, &$q), "sirius_db_tools_QueryBuilder_4"), 'execute'), null);
		return $q->join(",");
	}
	public function _order($obj) {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::All($obj, array(new _hx_lambda(array(&$obj, &$r), "sirius_db_tools_QueryBuilder_5"), 'execute'), null);
		return $r->join(",");
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
		$r[$r->length] = $_g->_conditions($v, $props, $joiner);
	}
}
function sirius_db_tools_QueryBuilder_1(&$_g, &$b, &$joiner, &$obj, &$props, &$r, &$s, $p, $v1) {
	{
		if(Std::is($v1, _hx_qtype("sirius.db.Clause"))) {
			$r[$r->length] = $_g->_conditions($v1, $props, $v1->joiner());
		} else {
			$r[$r->length] = $_g->_conditions($v1, $props, $joiner);
		}
	}
}
function sirius_db_tools_QueryBuilder_2(&$_g, &$clause, &$entries, &$from, &$limit, &$parameters, &$to, $v) {
	{
		$_g->add($to, null, $v, null, null);
	}
}
function sirius_db_tools_QueryBuilder_3(&$parameters, &$q, $p) {
	{
		$q[$q->length] = $p;
	}
}
function sirius_db_tools_QueryBuilder_4(&$parameters, &$q, $p, $v) {
	{
		$q[$q->length] = _hx_string_or_null($p) . "=:" . _hx_string_or_null($p);
	}
}
function sirius_db_tools_QueryBuilder_5(&$obj, &$r, $p, $v) {
	{
		$r[$r->length] = _hx_string_or_null($p) . _hx_string_or_null((sirius_db_tools_QueryBuilder_6($__hx__this, $obj, $p, $r, $v)));
	}
}
function sirius_db_tools_QueryBuilder_6(&$__hx__this, &$obj, &$p, &$r, &$v) {
	if($v !== null) {
		return " " . Std::string($v);
	} else {
		return "";
	}
}
