<?php
/**
 */

namespace jotun\php\db\tools;

use \php\Boot;
use \haxe\Exception;
use \jotun\utils\Dice;
use \jotun\errors\Error;
use \jotun\php\db\pdo\Statement;
use \php\_Boot\HxString;
use \jotun\errors\IError;

/**
 * ...
 * @author Rafael Moreira
 */
class Command implements ICommand {
	/**
	 * @var IError[]|\Array_hx
	 */
	public $_errors;
	/**
	 * @var string[]|\Array_hx
	 */
	public $_log;
	/**
	 * @var mixed[]|\Array_hx
	 */
	public $_parameters;
	/**
	 * @var string
	 */
	public $_query;
	/**
	 * @var IError[]|\Array_hx
	 */
	public $errors;
	/**
	 * @var mixed[]|\Array_hx
	 */
	public $result;
	/**
	 * @var Statement
	 */
	public $statement;
	/**
	 * @var bool
	 */
	public $success;

	/**
	 * @param Statement $statement
	 * @param string $query
	 * @param mixed[]|\Array_hx $parameters
	 * @param IError[]|\Array_hx $errors
	 * @param string[]|\Array_hx $log
	 * 
	 * @return void
	 */
	public function __construct ($statement, $query, $parameters, $errors, $log) {
		#src/jotun/php/db/tools/Command.hx:37: characters 3-13
		$this->_log = $log;
		#src/jotun/php/db/tools/Command.hx:38: characters 3-19
		$this->_errors = $errors;
		#src/jotun/php/db/tools/Command.hx:39: characters 3-17
		$this->_query = $query;
		#src/jotun/php/db/tools/Command.hx:40: characters 3-29
		$this->statement = $statement;
		#src/jotun/php/db/tools/Command.hx:41: lines 41-43
		if ($parameters !== null) {
			#src/jotun/php/db/tools/Command.hx:42: characters 4-20
			$this->bind($parameters);
		}
	}

	/**
	 * @param mixed $v
	 * 
	 * @return int
	 */
	public function _getType ($v) {
		#src/jotun/php/db/tools/Command.hx:47: lines 47-57
		if (is_string($v)) {
			#src/jotun/php/db/tools/Command.hx:48: characters 4-46
			return \PDO::PARAM_STR;
		} else if ((is_float($v) || is_int($v))) {
			#src/jotun/php/db/tools/Command.hx:50: characters 4-46
			return \PDO::PARAM_INT;
		} else if (is_bool($v)) {
			#src/jotun/php/db/tools/Command.hx:52: characters 4-46
			return \PDO::PARAM_INT;
		} else if ($v === null) {
			#src/jotun/php/db/tools/Command.hx:54: characters 4-47
			return \PDO::PARAM_NULL;
		} else {
			#src/jotun/php/db/tools/Command.hx:56: characters 4-46
			return \PDO::PARAM_STR;
		}
	}

	/**
	 * @param mixed[]|\Array_hx $parameters
	 * 
	 * @return ICommand
	 */
	public function bind ($parameters) {
		#src/jotun/php/db/tools/Command.hx:60: lines 60-69
		$_gthis = $this;
		#src/jotun/php/db/tools/Command.hx:61: characters 3-27
		$this->_parameters = $parameters;
		#src/jotun/php/db/tools/Command.hx:62: lines 62-67
		if ($this->statement !== null) {
			#src/jotun/php/db/tools/Command.hx:63: lines 63-66
			Dice::All($parameters, function ($p, $v) use (&$_gthis) {
				#src/jotun/php/db/tools/Command.hx:64: characters 5-45
				$_gthis->statement->bindValue(1 + $p, $v, $_gthis->_getType($v));
				#src/jotun/php/db/tools/Command.hx:65: characters 5-40
				\Reflect::setField($_gthis->_parameters, $p, $v);
			});
		}
		#src/jotun/php/db/tools/Command.hx:68: characters 3-14
		return $this;
	}

	/**
	 * @param \Closure $handler
	 * @param mixed $type
	 * @param mixed[]|\Array_hx $parameters
	 * 
	 * @return ICommand
	 */
	public function execute ($handler = null, $type = null, $parameters = null) {
		#src/jotun/php/db/tools/Command.hx:72: lines 72-95
		if ($this->statement !== null) {
			#src/jotun/php/db/tools/Command.hx:73: characters 4-29
			$p = null;
			#src/jotun/php/db/tools/Command.hx:74: lines 74-76
			if ($parameters !== null) {
				#src/jotun/php/db/tools/Command.hx:75: characters 5-35
				$p = $parameters->arr;
			}
			#src/jotun/php/db/tools/Command.hx:77: lines 77-89
			try {
				#src/jotun/php/db/tools/Command.hx:78: characters 5-35
				$this->success = $this->statement->execute($p);
				#src/jotun/php/db/tools/Command.hx:79: lines 79-81
				if (!$this->success) {
					#src/jotun/php/db/tools/Command.hx:80: characters 6-12
					$tmp = $this->get_errors();
					#src/jotun/php/db/tools/Command.hx:80: characters 13-26
					$tmp1 = $this->get_errors()->length;
					#src/jotun/php/db/tools/Command.hx:80: characters 40-61
					$tmp2 = $this->statement->errorCode();
					#src/jotun/php/db/tools/Command.hx:80: characters 6-102
					$tmp->offsetSet($tmp1, new Error($tmp2, \Array_hx::wrap($this->statement->errorInfo())));
				}
				#src/jotun/php/db/tools/Command.hx:82: characters 5-26
				$this->statement = null;
			} catch(\Throwable $_g) {
				#src/jotun/php/db/tools/Command.hx:83: characters 12-13
				$e = Exception::caught($_g)->unwrap();
				#src/jotun/php/db/tools/Command.hx:84: lines 84-88
				if (is_string($e)) {
					#src/jotun/php/db/tools/Command.hx:85: characters 6-45
					$this->get_errors()->offsetSet($this->get_errors()->length, new Error(0, $e));
				} else {
					#src/jotun/php/db/tools/Command.hx:87: characters 6-12
					$tmp = $this->get_errors();
					#src/jotun/php/db/tools/Command.hx:87: characters 13-26
					$tmp1 = $this->get_errors()->length;
					#src/jotun/php/db/tools/Command.hx:87: characters 40-51
					$tmp2 = $e->getCode();
					#src/jotun/php/db/tools/Command.hx:87: characters 6-68
					$tmp->offsetSet($tmp1, new Error($tmp2, $e->getMessage()));
				}
			}
			#src/jotun/php/db/tools/Command.hx:90: lines 90-92
			if ($this->_log !== null) {
				#src/jotun/php/db/tools/Command.hx:91: characters 5-64
				$this->_log->offsetSet($this->_log->length, ((($this->success ? "[1]" : "[0]"))??'null') . " " . ($this->log()??'null'));
			}
		} else {
			#src/jotun/php/db/tools/Command.hx:94: characters 4-83
			$this->get_errors()->offsetSet($this->get_errors()->length, new Error(0, "A connection with database is required."));
		}
		#src/jotun/php/db/tools/Command.hx:96: characters 3-14
		return $this;
	}

	/**
	 * @return IError[]|\Array_hx
	 */
	public function get_errors () {
		#src/jotun/php/db/tools/Command.hx:34: characters 48-62
		return $this->_errors;
	}

	/**
	 * @return string
	 */
	public function log () {
		#src/jotun/php/db/tools/Command.hx:99: lines 99-111
		$_gthis = $this;
		#src/jotun/php/db/tools/Command.hx:100: characters 3-44
		$r = HxString::split($this->_query, "?");
		#src/jotun/php/db/tools/Command.hx:101: lines 101-109
		Dice::All($r, function ($p, $v) use (&$r, &$_gthis) {
			#src/jotun/php/db/tools/Command.hx:102: lines 102-108
			if ($p < $_gthis->_parameters->length) {
				#src/jotun/php/db/tools/Command.hx:103: characters 5-36
				$e = ($_gthis->_parameters->arr[$p] ?? null);
				#src/jotun/php/db/tools/Command.hx:104: lines 104-106
				if (is_string($e)) {
					#src/jotun/php/db/tools/Command.hx:105: characters 6-23
					$e = "\"" . \Std::string($e) . "\"";
				}
				#src/jotun/php/db/tools/Command.hx:107: characters 5-17
				$r->offsetSet($p, ($v??'null') . \Std::string($e));
			}
		});
		#src/jotun/php/db/tools/Command.hx:110: characters 3-20
		return $r->join("");
	}

	/**
	 * @return string
	 */
	public function query () {
		#src/jotun/php/db/tools/Command.hx:114: characters 3-16
		return $this->_query;
	}
}

Boot::registerClass(Command::class, 'jotun.php.db.tools.Command');
Boot::registerGetters('jotun\\php\\db\\tools\\Command', [
	'errors' => true
]);
