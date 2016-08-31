<?php

class sirius_db_objects_Column {
	public function __construct($data) {
		if(!php_Boot::$skip_constructor) {
		$this->name = $data->COLUMN_NAME;
		$this->nullable = _hx_equal($data->IS_NULLABLE, "YES");
		$this->position = Std::parseInt($data->ORDINAL_POSITION);
		$this->value = $data->COLUMN_DEFAULT;
		$this->dataType = $data->DATA_TYPE;
		$this->columnType = $data->COLUMN_TYPE;
		$this->key = $data->COLUMN_KEY;
		$this->extra = $data->EXTRA;
		$this->charset = $data->CHARACTER_SET_NAME;
		$this->comment = $data->COLUMN_COMMENT;
		$this->length = Std::parseInt($data->CHARACTER_MAXIMUM_LENGTH);
		$this->previleges = _hx_string_call($data->PRIVILEGES, "split", array(","));
	}}
	public $name;
	public $nullable;
	public $value;
	public $dataType;
	public $columnType;
	public $charset;
	public $key;
	public $extra;
	public $comment;
	public $position;
	public $length;
	public $previleges;
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
	function __toString() { return 'sirius.db.objects.Column'; }
}
