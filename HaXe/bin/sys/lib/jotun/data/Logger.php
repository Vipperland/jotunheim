<?php
/**
 * Generated by Haxe 4.3.4
 */

namespace jotun\data;

use \php\Boot;
use \jotun\logical\Flag;
use \jotun\utils\Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Logger {
	/**
	 * @var int
	 */
	const BROADCAST = 6;
	/**
	 * @var int
	 */
	const ERROR = 3;
	/**
	 * @var int
	 */
	const MESSAGE = 0;
	/**
	 * @var int
	 */
	const OBSOLETE = 7;
	/**
	 * @var int
	 */
	const QUERY = 5;
	/**
	 * @var int
	 */
	const SYSTEM = 1;
	/**
	 * @var int
	 */
	const TODO = 4;
	/**
	 * @var int
	 */
	const WARNING = 2;

	/**
	 * @var \Closure[]|\Array_hx
	 */
	public $_events;
	/**
	 * @var Flag
	 */
	public $_level;

	/**
	 * @return void
	 */
	public function __construct () {
		#src/jotun/data/Logger.hx:30: characters 28-72
		$this->_level = new Flag(3);
		#src/jotun/data/Logger.hx:41: characters 3-15
		$this->_events = new \Array_hx();
		#src/jotun/data/Logger.hx:45: characters 4-45
		\Reflect::setField($this->_events, "query", Boot::getInstanceClosure($this, 'query'));
	}

	/**
	 * @param int $i
	 * 
	 * @return void
	 */
	public function disable ($i) {
		#src/jotun/data/Logger.hx:37: characters 3-17
		$this->_level->drop($i);
	}

	/**
	 * @param mixed $q
	 * 
	 * @return void
	 */
	public function dump ($q) {
		#src/jotun/data/Logger.hx:75: characters 4-15
		\var_dump($q);
	}

	/**
	 * @param int $i
	 * 
	 * @return void
	 */
	public function enable ($i) {
		#src/jotun/data/Logger.hx:33: characters 3-16
		$this->_level->put($i);
	}

	/**
	 * @param \Closure $handler
	 * 
	 * @return void
	 */
	public function listen ($handler) {
		#src/jotun/data/Logger.hx:62: characters 3-36
		$this->_events->offsetSet($this->_events->length, $handler);
	}

	/**
	 * @return void
	 */
	public function mute () {
		#src/jotun/data/Logger.hx:50: lines 50-52
		if (\Lambda::indexOf($this->_events, Boot::getInstanceClosure($this, 'query')) !== -1) {
			#src/jotun/data/Logger.hx:51: characters 4-24
			$this->_events->splice(0, 1);
		}
	}

	/**
	 * @param mixed $q
	 * @param int $type
	 * 
	 * @return void
	 */
	public function push ($q, $type) {
		#src/jotun/data/Logger.hx:66: lines 66-68
		Dice::Values($this->_events, function ($v) use (&$type, &$q) {
			#src/jotun/data/Logger.hx:67: characters 4-14
			$v($q, $type);
		});
	}

	/**
	 * @param mixed $q
	 * @param int $type
	 * 
	 * @return void
	 */
	public function query ($q, $type) {
		#src/jotun/data/Logger.hx:80: lines 80-82
		if (!$this->_level->test($type)) {
			#src/jotun/data/Logger.hx:81: characters 4-10
			return;
		}
		#src/jotun/data/Logger.hx:83: characters 3-21
		$t = "";
		#src/jotun/data/Logger.hx:84: lines 84-96
		if ($type !== null) {
			#src/jotun/data/Logger.hx:85: lines 85-95
			if ($type === 0) {
				#src/jotun/data/Logger.hx:86: characters 14-26
				$t = "[MESSAGE] ";
			} else if ($type === 1) {
				#src/jotun/data/Logger.hx:87: characters 14-26
				$t = "[>SYSTEM] ";
			} else if ($type === 2) {
				#src/jotun/data/Logger.hx:88: characters 14-26
				$t = "[WARNING] ";
			} else if ($type === 3) {
				#src/jotun/data/Logger.hx:89: characters 14-26
				$t = "[!ERROR!] ";
			} else if ($type === 4) {
				#src/jotun/data/Logger.hx:90: characters 14-26
				$t = "[//TODO*] ";
			} else if ($type === 5) {
				#src/jotun/data/Logger.hx:91: characters 14-26
				$t = "[\$QUERY*] ";
			} else if ($type === 6) {
				#src/jotun/data/Logger.hx:92: characters 14-26
				$t = "[BRDCAST] ";
			} else if ($type === 7) {
				#src/jotun/data/Logger.hx:93: characters 14-26
				$t = "[OBSOLET] ";
			} else {
				#src/jotun/data/Logger.hx:94: characters 15-17
				$t = "";
			}
		}
		#src/jotun/data/Logger.hx:101: characters 3-10
		$this->dump($q);
	}

	/**
	 * @return void
	 */
	public function unmute () {
		#src/jotun/data/Logger.hx:56: lines 56-58
		if (\Lambda::indexOf($this->_events, Boot::getInstanceClosure($this, 'query')) === -1) {
			#src/jotun/data/Logger.hx:57: characters 4-26
			$_this = $this->_events;
			$_this->length = \array_unshift($_this->arr, Boot::getInstanceClosure($this, 'query'));
		}
	}
}

Boot::registerClass(Logger::class, 'jotun.data.Logger');
