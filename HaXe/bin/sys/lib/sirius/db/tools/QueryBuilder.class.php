<?php

class sirius_db_tools_QueryBuilder implements sirius_db_tools_IQueryBuilder{
	public function __construct($gate) {
		if(!php_Boot::$skip_constructor) {
		$this->_gate = $gate;
	}}
	public $_gate;
	public function _insert($parameters) {
		$q = (new _hx_array(array()));
		sirius_utils_Dice::Params($parameters, array(new _hx_lambda(array(&$parameters, &$q), "sirius_db_tools_QueryBuilder_0"), 'execute'), null);
		return "(" . _hx_string_or_null($q->join(",")) . ") VALUES (:" . _hx_string_or_null($q->join(",:")) . ")";
	}
	public function _updateSet($parameters) {
		$q = (new _hx_array(array()));
		sirius_utils_Dice::All($parameters, array(new _hx_lambda(array(&$parameters, &$q), "sirius_db_tools_QueryBuilder_1"), 'execute'), null);
		return $q->join(",");
	}
	public function _order($obj) {
		$r = (new _hx_array(array()));
		sirius_utils_Dice::All($obj, array(new _hx_lambda(array(&$obj, &$r), "sirius_db_tools_QueryBuilder_2"), 'execute'), null);
		return $r->join(",");
	}
	public function _conditions($obj, $props, $joiner, $i = null) {
		if($i === null) {
			$i = 0;
		}
		$_g = $this;
		$r = (new _hx_array(array()));
		$s = $joiner;
		$b = true;
		if(Std::is($obj, _hx_qtype("sirius.db.Clause"))) {
			sirius_utils_Dice::Values($obj->conditions, array(new _hx_lambda(array(&$_g, &$b, &$i, &$joiner, &$obj, &$props, &$r, &$s), "sirius_db_tools_QueryBuilder_3"), 'execute'), null);
			$s = $obj->joiner();
		} else {
			if(Std::is($obj, _hx_qtype("Array"))) {
				sirius_utils_Dice::All($obj, array(new _hx_lambda(array(&$_g, &$b, &$i, &$joiner, &$obj, &$props, &$r, &$s), "sirius_db_tools_QueryBuilder_4"), 'execute'), null);
			} else {
				$r[$r->length] = sirius_utils_Filler::to($obj->condition, _hx_anonymous(array("p" => $obj->param)), null);
				$props->{"in_" . Std::string($obj->i)} = $obj->value;
			}
		}
		if($r->length > 0) {
			$b = $r->length > 1;
			return _hx_string_or_null(((($b) ? "(" : ""))) . _hx_string_or_null($r->join($s)) . _hx_string_or_null(((($b) ? ")" : "")));
		} else {
			return null;
		}
	}
	public function _assembleBody($clause = null, $parameters = null, $order = null, $limit = null) {
		$q = "";
		if($clause !== null) {
			$q .= " WHERE " . _hx_string_or_null($this->_conditions($clause, $parameters, " || ", null));
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
	public function copy($from, $to, $clause = null, $filter = null, $limit = null) {
		$_g = $this;
		$entries = $this->find("*", $from, $clause, null, $limit)->result;
		sirius_utils_Dice::Values($entries, array(new _hx_lambda(array(&$_g, &$clause, &$entries, &$filter, &$from, &$limit, &$to), "sirius_db_tools_QueryBuilder_5"), 'execute'), null);
		return null;
	}
	public function fKey($table, $reference, $key = null, $target = null, $field = null, $delete = null, $update = null) {
		if($update === null) {
			$update = "RESTRICT";
		}
		if($delete === null) {
			$delete = "RESTRICT";
		}
		if($key === null) {
			return $this->_gate->prepare("ALTER TABLE " . _hx_string_or_null($table) . " DROP FOREIGN KEY " . _hx_string_or_null($reference), null, null);
		} else {
			return $this->_gate->prepare("ALTER TABLE " . _hx_string_or_null($table) . " ADD CONSTRAINT " . _hx_string_or_null($reference) . " FOREIGN KEY (" . _hx_string_or_null($key) . ") REFERENCES " . _hx_string_or_null($target) . "(" . _hx_string_or_null($field) . ") ON DELETE " . _hx_string_or_null(strtoupper($delete)) . " ON UPDATE " . _hx_string_or_null(strtoupper($update)) . ";", null, null);
		}
	}
	public function truncate($table) {
		return $this->_gate->prepare("TRUNCATE :table", _hx_anonymous(array("table" => $table)), null);
	}
	public function rename($table, $to) {
		return $this->_gate->prepare("RENAME TABLE :oldname TO :newname", _hx_anonymous(array("oldname" => $table, "newname" => $to)), null);
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
function sirius_db_tools_QueryBuilder_0(&$parameters, &$q, $p) {
	{
		$q[$q->length] = $p;
	}
}
function sirius_db_tools_QueryBuilder_1(&$parameters, &$q, $p, $v) {
	{
		$q[$q->length] = _hx_string_or_null($p) . "=:" . _hx_string_or_null($p);
	}
}
function sirius_db_tools_QueryBuilder_2(&$obj, &$r, $p, $v) {
	{
		$r[$r->length] = _hx_string_or_null($p) . _hx_string_or_null((sirius_db_tools_QueryBuilder_6($__hx__this, $obj, $p, $r, $v)));
	}
}
function sirius_db_tools_QueryBuilder_3(&$_g, &$b, &$i, &$joiner, &$obj, &$props, &$r, &$s, $v) {
	{
		$v = $_g->_conditions($v, $props, $joiner, null);
		if($v !== null) {
			$r[$r->length] = $v;
		}
	}
}
function sirius_db_tools_QueryBuilder_4(&$_g, &$b, &$i, &$joiner, &$obj, &$props, &$r, &$s, $p, $v1) {
	{
		if(Std::is($v1, _hx_qtype("sirius.db.Clause"))) {
			$v1 = $_g->_conditions($v1, $props, $v1->joiner(), null);
			if($v1 !== null) {
				$r[$r->length] = $v1;
			}
		} else {
			$v1 = $_g->_conditions($v1, $props, $joiner, null);
			if($v1 !== null) {
				$r[$r->length] = $v1;
			}
		}
	}
}
function sirius_db_tools_QueryBuilder_5(&$_g, &$clause, &$entries, &$filter, &$from, &$limit, &$to, $v) {
	{
		if($filter !== null) {
			$v = call_user_func_array($filter, array($v));
		}
		$_g->add($to, null, $v, null, null);
	}
}
function sirius_db_tools_QueryBuilder_6(&$__hx__this, &$obj, &$p, &$r, &$v) {
	if($v !== null) {
		return " " . Std::string($v);
	} else {
		return "";
	}
}
