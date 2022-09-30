<?php
/**
 */

namespace jotun\gaming\actions;

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\tools\Utils;
use \jotun\utils\Dice;

/**
 * ...
 * @author Rim Project
 */
class Action extends Resolution {
	/**
	 * @var mixed
	 */
	static public $cache;
	/**
	 * @var ActionQueryGroup
	 */
	static public $commands;

	/**
	 * @var Requirement[]|\Array_hx
	 */
	public $requirements;
	/**
	 * @var int
	 */
	public $target;

	/**
	 * @param Action $evt
	 * @param IEventContext $context
	 * @param bool $success
	 * @param int $score
	 * @param int $position
	 * 
	 * @return void
	 */
	public static function _log ($evt, $context, $success, $score, $position) {
		#src/jotun/gaming/actions/Action.hx:90: lines 90-92
		if ($context->log !== null) {
			#src/jotun/gaming/actions/Action.hx:91: characters 4-267
			$_this = $context->log;
			#src/jotun/gaming/actions/Action.hx:91: characters 21-81
			$x = (Utils::prefix("", $context->ident + $context->chain, "\x09")??'null') . "↑ ";
			#src/jotun/gaming/actions/Action.hx:91: characters 130-180
			$x1 = (Utils::isValid($evt->id) ? "#{" . ($evt->id??'null') . "} " : "");
			#src/jotun/gaming/actions/Action.hx:91: characters 4-267
			$x2 = ($x??'null') . ((($success ? "SUCCESS" : "FAIL"))??'null') . " ACTION " . ($x1??'null') . "[" . ($position??'null') . "] score:" . ($score??'null') . "/" . ($evt->target??'null') . " queries:" . ($evt->length()??'null');
			$_this->arr[$_this->length++] = $x2;
		}
	}

	/**
	 * @param string $id
	 * 
	 * @return Action
	 */
	public static function load ($id) {
		#src/jotun/gaming/actions/Action.hx:23: characters 3-39
		return \Reflect::field(Action::$cache, $id);
	}

	/**
	 * @param Action $action
	 * 
	 * @return void
	 */
	public static function save ($action) {
		#src/jotun/gaming/actions/Action.hx:19: characters 3-45
		\Reflect::setField(Action::$cache, $action->id, $action);
	}

	/**
	 * @param string $type
	 * @param mixed $data
	 * 
	 * @return void
	 */
	public function __construct ($type, $data) {
		#src/jotun/gaming/actions/Action.hx:32: lines 32-58
		$_gthis = $this;
		#src/jotun/gaming/actions/Action.hx:33: characters 3-20
		parent::__construct($type, $data);
		#src/jotun/gaming/actions/Action.hx:35: characters 3-20
		$this->requirements = new \Array_hx();
		#src/jotun/gaming/actions/Action.hx:36: characters 3-17
		$i = 0;
		#src/jotun/gaming/actions/Action.hx:37: lines 37-49
		Dice::All(Boot::dynamicField($data, 'requirements'), function ($p, $v) use (&$i, &$_gthis, &$type) {
			#src/jotun/gaming/actions/Action.hx:38: lines 38-40
			if (is_string($v)) {
				#src/jotun/gaming/actions/Action.hx:39: characters 5-43
				$v = EventController::loadRequirement($v);
			}
			#src/jotun/gaming/actions/Action.hx:41: lines 41-48
			if ($v !== null) {
				#src/jotun/gaming/actions/Action.hx:42: lines 42-46
				if (($v instanceof Requirement)) {
					#src/jotun/gaming/actions/Action.hx:43: characters 6-30
					$_gthis->requirements->offsetSet($i, $v);
				} else {
					#src/jotun/gaming/actions/Action.hx:45: characters 6-64
					$_gthis->requirements->offsetSet($i, new Requirement(($type??'null') . "[" . \Std::string($p) . "]", $v));
				}
				#src/jotun/gaming/actions/Action.hx:47: characters 5-8
				$i += 1;
			}
		});
		#src/jotun/gaming/actions/Action.hx:51: characters 3-32
		$this->target = (int)(Boot::dynamicField($data, 'target'));
		#src/jotun/gaming/actions/Action.hx:52: lines 52-54
		if ($this->target === null) {
			#src/jotun/gaming/actions/Action.hx:53: characters 4-32
			$this->target = $this->requirements->length;
		}
		#src/jotun/gaming/actions/Action.hx:55: lines 55-57
		if (Utils::isValid(Boot::dynamicField($data, 'id'))) {
			#src/jotun/gaming/actions/Action.hx:56: characters 4-36
			EventController::saveAction($this);
		}
	}

	/**
	 * @param IEventContext $context
	 * @param int $position
	 * 
	 * @return bool
	 */
	public function run ($context, $position) {
		#src/jotun/gaming/actions/Action.hx:62: characters 3-26
		$resolution = 0;
		#src/jotun/gaming/actions/Action.hx:63: characters 3-18
		++$context->ident;
		#src/jotun/gaming/actions/Action.hx:64: lines 64-73
		Dice::All($this->requirements, function ($p, $r) use (&$context, &$resolution) {
			#src/jotun/gaming/actions/Action.hx:65: characters 4-43
			$result = $r->verify($context, $p);
			#src/jotun/gaming/actions/Action.hx:66: lines 66-72
			if ($result) {
				#src/jotun/gaming/actions/Action.hx:67: characters 5-17
				$resolution += 1;
				#src/jotun/gaming/actions/Action.hx:68: characters 5-29
				return $r->cancelOnSuccess;
			} else {
				#src/jotun/gaming/actions/Action.hx:70: characters 5-17
				$resolution -= 1;
				#src/jotun/gaming/actions/Action.hx:71: characters 5-26
				return $r->cancelOnFail;
			}
		});
		#src/jotun/gaming/actions/Action.hx:74: characters 3-18
		--$context->ident;
		#src/jotun/gaming/actions/Action.hx:76: characters 3-116
		$success = ($this->target === 0) || (($this->target > 0) && ($resolution >= $this->target)) || (($this->target < 0) && ($resolution <= $this->target));
		#src/jotun/gaming/actions/Action.hx:77: lines 77-79
		if ($context->debug) {
			#src/jotun/gaming/actions/Action.hx:78: characters 4-54
			Action::_log($this, $context, $success, $resolution, $position);
		}
		#src/jotun/gaming/actions/Action.hx:80: lines 80-85
		if ($success) {
			#src/jotun/gaming/actions/Action.hx:81: characters 4-30
			$_this = $context->history;
			$_this->arr[$_this->length++] = $this;
			#src/jotun/gaming/actions/Action.hx:82: lines 82-84
			if (Utils::isValid($this->query)) {
				#src/jotun/gaming/actions/Action.hx:83: characters 5-38
				Action::$commands->eventRun($this->query, $context);
			}
		}
		#src/jotun/gaming/actions/Action.hx:86: characters 3-35
		return $this->resolve($success, $context);
	}

	/**
	 * @internal
	 * @access private
	 */
	static public function __hx__init ()
	{
		static $called = false;
		if ($called) return;
		$called = true;


		self::$cache = new HxAnon();
		self::$commands = new ActionQueryGroup();
	}
}

Boot::registerClass(Action::class, 'jotun.gaming.actions.Action');
Action::__hx__init();
