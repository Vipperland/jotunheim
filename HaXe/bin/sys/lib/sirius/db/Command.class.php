<?php

class sirius_db_Command implements sirius_db_ICommand{
	public function __construct($statement, $query, $parameters = null, $errors) {
		if(!php_Boot::$skip_constructor) {
		$GLOBALS['%s']->push("sirius.db.Command::new");
		$__hx__spos = $GLOBALS['%s']->length;
		$this->_errors = $errors;
		$this->_query = $query;
		$this->statement = $statement;
		if($parameters !== null) {
			$this->bind($parameters);
		}
		$GLOBALS['%s']->pop();
	}}
	public $_query;
	public $_parameters;
	public $_errors;
	public $success;
	public $statement;
	public $result;
	public $errors;
	public function get_errors() {
		$GLOBALS['%s']->push("sirius.db.Command::get_errors");
		$__hx__spos = $GLOBALS['%s']->length;
		{
			$tmp = $this->_errors;
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
	public function bind($parameters) {
		$GLOBALS['%s']->push("sirius.db.Command::bind");
		$__hx__spos = $GLOBALS['%s']->length;
		$_g = $this;
		$this->_parameters = $parameters;
		if($this->statement !== null) {
			$isArray = Std::is($parameters, _hx_qtype("Array"));
			sirius_utils_Dice::All($parameters, array(new _hx_lambda(array(&$_g, &$isArray, &$parameters), "sirius_db_Command_0"), 'execute'), null);
		}
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function execute($handler = null, $type = null, $parameters = null) {
		$GLOBALS['%s']->push("sirius.db.Command::execute");
		$__hx__spos = $GLOBALS['%s']->length;
		if($this->statement !== null) {
			if($type === null) {
				$type = \PDO::FETCH_OBJ;
			}
			$p = null;
			if($parameters !== null) {
				$p = php_Lib::toPhpArray($parameters);
			}
			try {
				$this->success = $this->statement->execute($p);
				if($this->success) {
					{
						$a = $this->statement->fetchAll($type);
						$this->result = new _hx_array($a);
					}
					if($handler !== null) {
						$this->fetch($handler);
					}
				} else {
					_hx_array_assign($this->get_errors(), $this->get_errors()->length, new sirius_errors_Error($this->statement->errorCode(), sirius_db_Command_1($this, $handler, $p, $parameters, $type), null));
				}
			}catch(Exception $__hx__e) {
				$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
				$e = $_ex_;
				{
					$GLOBALS['%e'] = (new _hx_array(array()));
					while($GLOBALS['%s']->length >= $__hx__spos) {
						$GLOBALS['%e']->unshift($GLOBALS['%s']->pop());
					}
					$GLOBALS['%s']->push($GLOBALS['%e'][0]);
					if(Std::is($e, _hx_qtype("String"))) {
						_hx_array_assign($this->get_errors(), $this->get_errors()->length, new sirius_errors_Error(0, $e, null));
					} else {
						_hx_array_assign($this->get_errors(), $this->get_errors()->length, new sirius_errors_Error($e->getCode(), $e->getMessage(), null));
					}
				}
			}
		} else {
			_hx_array_assign($this->get_errors(), $this->get_errors()->length, new sirius_errors_Error(0, "Null statement. Database is not connected.", null));
		}
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function fetch($handler) {
		$GLOBALS['%s']->push("sirius.db.Command::fetch");
		$__hx__spos = $GLOBALS['%s']->length;
		sirius_utils_Dice::Values($this->result, array(new _hx_lambda(array(&$handler), "sirius_db_Command_2"), 'execute'), null);
		{
			$GLOBALS['%s']->pop();
			return $this;
		}
		$GLOBALS['%s']->pop();
	}
	public function find($param, $values, $limit = null) {
		$GLOBALS['%s']->push("sirius.db.Command::find");
		$__hx__spos = $GLOBALS['%s']->length;
		if($limit === null) {
			$limit = 0;
		}
		$filter = (new _hx_array(array()));
		sirius_utils_Dice::Values($this->result, array(new _hx_lambda(array(&$filter, &$limit, &$param, &$values), "sirius_db_Command_3"), 'execute'), null);
		{
			$GLOBALS['%s']->pop();
			return $filter;
		}
		$GLOBALS['%s']->pop();
	}
	public function log() {
		$GLOBALS['%s']->push("sirius.db.Command::log");
		$__hx__spos = $GLOBALS['%s']->length;
		$q = $this->_query;
		sirius_utils_Dice::All($this->_parameters, array(new _hx_lambda(array(&$q), "sirius_db_Command_4"), 'execute'), null);
		{
			$GLOBALS['%s']->pop();
			return $q;
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
	static $__properties__ = array("get_errors" => "get_errors");
	function __toString() { return 'sirius.db.Command'; }
}
function sirius_db_Command_0(&$_g, &$isArray, &$parameters, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.db.Command::bind@49");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if($isArray) {
			$_g->statement->setAttribute($p, $v);
		} else {
			$_g->statement->bindValue($p, $v, null);
		}
		{
			$field = $p;
			$_g->_parameters->{$field} = $v;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_db_Command_1(&$__hx__this, &$handler, &$p, &$parameters, &$type) {
	{
		$value = $__hx__this->statement->errorInfo();
		return haxe_Json::phpJsonEncode($value, null, null);
	}
}
function sirius_db_Command_2(&$handler, $v) {
	{
		$GLOBALS['%s']->push("sirius.db.Command::fetch@85");
		$__hx__spos2 = $GLOBALS['%s']->length;
		{
			$tmp = call_user_func_array($handler, array(new sirius_data_DataSet($v)));
			$GLOBALS['%s']->pop();
			return $tmp;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_db_Command_3(&$filter, &$limit, &$param, &$values, $v) {
	{
		$GLOBALS['%s']->push("sirius.db.Command::find@91");
		$__hx__spos2 = $GLOBALS['%s']->length;
		if(sirius_utils_Dice::Match((new _hx_array(array(Reflect::field($v, $param)))), $values, 1) > 0) {
			$filter[$filter->length] = $v;
			{
				$tmp = sirius_db_Command_5($__hx__this, $filter, $limit, $param, $v, $values) && sirius_db_Command_6($__hx__this, $filter, $limit, $param, $v, $values);
				$GLOBALS['%s']->pop();
				return $tmp;
			}
		}
		{
			$GLOBALS['%s']->pop();
			return false;
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_db_Command_4(&$q, $p, $v) {
	{
		$GLOBALS['%s']->push("sirius.db.Command::log@103");
		$__hx__spos2 = $GLOBALS['%s']->length;
		$sub = ":" . _hx_string_or_null($p);
		$by = $v;
		if($sub === "") {
			$q = implode(str_split ($q), $by);
		} else {
			$q = str_replace($sub, $by, $q);
		}
		$GLOBALS['%s']->pop();
	}
}
function sirius_db_Command_5(&$__hx__this, &$filter, &$limit, &$param, &$v, &$values) {
	{
		$aNeg = $limit < 0;
		$bNeg = 0 < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return $limit > 0;
		}
		unset($bNeg,$aNeg);
	}
}
function sirius_db_Command_6(&$__hx__this, &$filter, &$limit, &$param, &$v, &$values) {
	{
		$a = --$limit;
		return $a === 0;
	}
}
