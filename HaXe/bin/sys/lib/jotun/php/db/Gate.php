<?php
/**
 */

namespace jotun\php\db;

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\php\db\tools\ICommand;
use \haxe\Exception;
use \jotun\php\db\pdo\Connection;
use \jotun\php\db\tools\IQueryBuilder;
use \jotun\tools\Utils;
use \jotun\utils\Dice;
use \jotun\php\db\tools\ExtCommand;
use \jotun\errors\Error;
use \jotun\php\db\tools\IExtCommand;
use \jotun\php\db\objects\IDataTable;
use \jotun\php\db\pdo\Database;
use \jotun\php\db\tools\QueryBuilder;
use \jotun\errors\IError;
use \jotun\php\db\objects\DataTable;
use \jotun\php\db\tools\Command;

/**
 * ...
 * @author Rafael Moreira
 */
class Gate implements IGate {
	/**
	 * @var Connection
	 */
	public $_db;
	/**
	 * @var IError[]|\Array_hx
	 */
	public $_errors;
	/**
	 * @var string[]|\Array_hx
	 */
	public $_log;
	/**
	 * @var bool
	 */
	public $_logCommands;
	/**
	 * @var mixed
	 */
	public $_tables;
	/**
	 * @var Token
	 */
	public $_token;
	/**
	 * @var IQueryBuilder
	 */
	public $builder;
	/**
	 * @var ICommand
	 */
	public $command;
	/**
	 * @var IError[]|\Array_hx
	 */
	public $errors;
	/**
	 * @var string[]|\Array_hx
	 */
	public $log;

	/**
	 * @return void
	 */
	public function __construct () {
		#src/jotun/php/db/Gate.hx:65: characters 3-15
		$this->_errors = new \Array_hx();
		#src/jotun/php/db/Gate.hx:66: characters 3-12
		$this->_log = new \Array_hx();
		#src/jotun/php/db/Gate.hx:67: characters 3-23
		$this->_logCommands = false;
		#src/jotun/php/db/Gate.hx:68: characters 3-16
		$this->_tables = new HxAnon();
		#src/jotun/php/db/Gate.hx:69: characters 3-35
		$this->builder = new QueryBuilder($this);
	}

	/**
	 * @param string $field
	 * @param string $mode
	 * 
	 * @return mixed
	 */
	public function getInsertedID ($field = null, $mode = null) {
		#src/jotun/php/db/Gate.hx:55: characters 3-80
		$r = ($field !== null ? $this->_db->lastInsertId($field) : $this->_db->lastInsertId());
		#src/jotun/php/db/Gate.hx:56: lines 56-61
		if ($mode === null) {
			#src/jotun/php/db/Gate.hx:60: characters 14-22
			return $r;
		} else {
			#src/jotun/php/db/Gate.hx:56: characters 10-14
			if ($mode === "bool") {
				#src/jotun/php/db/Gate.hx:59: characters 18-41
				return Utils::boolean($r);
			} else if ($mode === "float") {
				#src/jotun/php/db/Gate.hx:58: characters 19-43
				return \Std::parseFloat($r);
			} else if ($mode === "int") {
				#src/jotun/php/db/Gate.hx:57: characters 17-39
				return \Std::parseInt($r);
			} else {
				#src/jotun/php/db/Gate.hx:60: characters 14-22
				return $r;
			}
		}
	}

	/**
	 * @return string
	 */
	public function getName () {
		#src/jotun/php/db/Gate.hx:51: characters 3-19
		return $this->_token->db;
	}

	/**
	 * @return string[]|\Array_hx
	 */
	public function getTableNames () {
		#src/jotun/php/db/Gate.hx:137: characters 3-28
		$r = new \Array_hx();
		#src/jotun/php/db/Gate.hx:138: lines 138-140
		Dice::Values($this->query("show tables")->execute()->result, function ($v) use (&$r) {
			#src/jotun/php/db/Gate.hx:139: characters 4-26
			Dice::Values($v, Boot::getInstanceClosure($r, 'push'));
		});
		#src/jotun/php/db/Gate.hx:141: characters 3-11
		return $r;
	}

	/**
	 * @return mixed
	 */
	public function getTables () {
		#src/jotun/php/db/Gate.hx:144: lines 144-150
		$_gthis = $this;
		#src/jotun/php/db/Gate.hx:145: characters 3-22
		$r = new HxAnon();
		#src/jotun/php/db/Gate.hx:146: lines 146-148
		Dice::Values($this->getTableNames(), function ($v) use (&$r, &$_gthis) {
			#src/jotun/php/db/Gate.hx:147: characters 4-36
			\Reflect::setField($r, $v, $_gthis->table($v));
		});
		#src/jotun/php/db/Gate.hx:149: characters 3-11
		return $r;
	}

	/**
	 * @return IError[]|\Array_hx
	 */
	public function get_errors () {
		#src/jotun/php/db/Gate.hx:45: characters 47-61
		return $this->_errors;
	}

	/**
	 * @return string[]|\Array_hx
	 */
	public function get_log () {
		#src/jotun/php/db/Gate.hx:48: characters 44-55
		return $this->_log;
	}

	/**
	 * @param string $table
	 * 
	 * @return bool
	 */
	public function ifTableExists ($table) {
		#src/jotun/php/db/Gate.hx:153: characters 3-46
		return $this->getTableNames()->indexOf($table) !== -1;
	}

	/**
	 * @return bool
	 */
	public function isOpen () {
		#src/jotun/php/db/Gate.hx:73: characters 10-43
		if ($this->_db !== null) {
			#src/jotun/php/db/Gate.hx:73: characters 25-43
			return $this->get_errors()->length === 0;
		} else {
			#src/jotun/php/db/Gate.hx:73: characters 10-43
			return false;
		}
	}

	/**
	 * @param Token $token
	 * @param bool $log
	 * 
	 * @return IGate
	 */
	public function open ($token, $log = false) {
		#src/jotun/php/db/Gate.hx:76: lines 76-89
		if ($log === null) {
			$log = false;
		}
		#src/jotun/php/db/Gate.hx:77: characters 3-21
		$this->_logCommands = $log;
		#src/jotun/php/db/Gate.hx:78: lines 78-87
		if (!$this->isOpen()) {
			#src/jotun/php/db/Gate.hx:79: characters 4-18
			$this->_token = $token;
			#src/jotun/php/db/Gate.hx:80: lines 80-85
			try {
				#src/jotun/php/db/Gate.hx:81: characters 5-78
				$this->_db = Database::connect($token->host, $token->user, $token->pass, $token->options);
				#src/jotun/php/db/Gate.hx:82: characters 5-27
				$this->setPdoAttributes(true);
			} catch(\Throwable $_g) {
				#src/jotun/php/db/Gate.hx:83: characters 12-13
				$e = Exception::caught($_g)->unwrap();
				#src/jotun/php/db/Gate.hx:84: characters 5-11
				$tmp = $this->get_errors();
				#src/jotun/php/db/Gate.hx:84: characters 12-25
				$tmp1 = $this->get_errors()->length;
				#src/jotun/php/db/Gate.hx:84: characters 39-50
				$tmp2 = $e->getCode();
				#src/jotun/php/db/Gate.hx:84: characters 5-67
				$tmp->offsetSet($tmp1, new Error($tmp2, $e->getMessage()));
			}
			#src/jotun/php/db/Gate.hx:86: characters 4-18
			$this->command = null;
		}
		#src/jotun/php/db/Gate.hx:88: characters 3-14
		return $this;
	}

	/**
	 * @param string $query
	 * @param mixed $parameters
	 * @param mixed $options
	 * 
	 * @return ICommand
	 */
	public function prepare ($query, $parameters = null, $options = null) {
		#src/jotun/php/db/Gate.hx:92: characters 3-28
		$pdo = null;
		#src/jotun/php/db/Gate.hx:93: lines 93-95
		if ($this->isOpen()) {
			#src/jotun/php/db/Gate.hx:94: characters 4-76
			$pdo = $this->_db->prepare($query, Boot::deref((($options === null ? new \Array_hx() : $options)))->arr);
		}
		#src/jotun/php/db/Gate.hx:96: characters 3-85
		$this->command = new Command($pdo, $query, $parameters, $this->_errors, ($this->_logCommands ? $this->_log : null));
		#src/jotun/php/db/Gate.hx:97: characters 3-17
		return $this->command;
	}

	/**
	 * @param string $query
	 * @param mixed $parameters
	 * 
	 * @return IExtCommand
	 */
	public function query ($query, $parameters = null) {
		#src/jotun/php/db/Gate.hx:101: characters 28-49
		$tmp = ($this->isOpen() ? $this->_db : null);
		#src/jotun/php/db/Gate.hx:101: characters 3-106
		$this->command = new ExtCommand($tmp, $query, $parameters, $this->_errors, ($this->_logCommands ? $this->_log : null));
		#src/jotun/php/db/Gate.hx:102: characters 3-22
		return $this->command;
	}

	/**
	 * @param mixed $table
	 * 
	 * @return mixed[]|\Array_hx
	 */
	public function schema ($table = null) {
		#src/jotun/php/db/Gate.hx:106: characters 3-25
		$r = null;
		#src/jotun/php/db/Gate.hx:107: lines 107-109
		if (!($table instanceof \Array_hx)) {
			#src/jotun/php/db/Gate.hx:108: characters 4-19
			$table = \Array_hx::wrap([$table]);
		}
		#src/jotun/php/db/Gate.hx:110: characters 3-34
		$tables = new \Array_hx();
		#src/jotun/php/db/Gate.hx:112: characters 4-43
		$clausule = Clause::EQUAL("TABLE_SCHEMA", $this->_token->db);
		#src/jotun/php/db/Gate.hx:111: lines 111-114
		$clausule1 = Clause::AND(\Array_hx::wrap([
			$clausule,
			Clause::OR($tables),
		]));
		#src/jotun/php/db/Gate.hx:115: lines 115-117
		Dice::Values($table, function ($v) use (&$tables) {
			#src/jotun/php/db/Gate.hx:116: characters 4-57
			$tables->offsetSet($tables->length, Clause::EQUAL("TABLE_NAME", $v));
		});
		#src/jotun/php/db/Gate.hx:118: characters 3-84
		return $this->builder->find("*", "INFORMATION_SCHEMA.COLUMNS", $clausule1)->execute()->result;
	}

	/**
	 * @param bool $value
	 * 
	 * @return IGate
	 */
	public function setPdoAttributes ($value) {
		#src/jotun/php/db/Gate.hx:122: characters 3-76
		$this->_db->setAttribute(\PDO::ATTR_STRINGIFY_FETCHES, $value);
		#src/jotun/php/db/Gate.hx:123: characters 3-75
		$this->_db->setAttribute(\PDO::ATTR_EMULATE_PREPARES, $value);
		#src/jotun/php/db/Gate.hx:124: characters 3-83
		$this->_db->setAttribute(\PDO::MYSQL_ATTR_USE_BUFFERED_QUERY, $value);
		#src/jotun/php/db/Gate.hx:125: characters 3-104
		$this->_db->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
		#src/jotun/php/db/Gate.hx:126: characters 3-14
		return $this;
	}

	/**
	 * @param string $table
	 * 
	 * @return IDataTable
	 */
	public function table ($table) {
		#src/jotun/php/db/Gate.hx:130: lines 130-132
		if (!\Reflect::hasField($this->_tables, $table)) {
			#src/jotun/php/db/Gate.hx:131: characters 4-64
			\Reflect::setField($this->_tables, $table, new DataTable($table, $this));
		}
		#src/jotun/php/db/Gate.hx:133: characters 3-39
		return \Reflect::field($this->_tables, $table);
	}
}

Boot::registerClass(Gate::class, 'jotun.php.db.Gate');
Boot::registerGetters('jotun\\php\\db\\Gate', [
	'log' => true,
	'errors' => true
]);
