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
class Requirement extends Resolution {
	/**
	 * @var mixed
	 */
	static public $cache;
	/**
	 * @var RequirementQueryGroup
	 */
	static public $commands;

	/**
	 * @var int
	 */
	public $target;

	/**
	 * @param Requirement $evt
	 * @param IEventContext $context
	 * @param bool $success
	 * @param int $score
	 * @param bool $reversed
	 * @param int $position
	 * 
	 * @return void
	 */
	public static function _log ($evt, $context, $success, $score, $reversed, $position) {
		#src/jotun/gaming/actions/Requirement.hx:61: lines 61-63
		if ($context->log !== null) {
			#src/jotun/gaming/actions/Requirement.hx:62: characters 4-306
			$_this = $context->log;
			#src/jotun/gaming/actions/Requirement.hx:62: characters 21-74
			$x = Utils::prefix("", $context->ident + $context->chain, "\x09");
			#src/jotun/gaming/actions/Requirement.hx:62: characters 132-182
			$x1 = (Utils::isValid($evt->id) ? "#{" . ($evt->id??'null') . "} " : "");
			#src/jotun/gaming/actions/Requirement.hx:62: characters 4-306
			$x2 = ($x??'null') . ((($success ? "└ SUCCESS" : "ꭙ FAIL"))??'null') . " REQUIREMENT " . ($x1??'null') . "[" . ($position??'null') . "]" . ((($reversed ? " REVERSED" : ""))??'null') . " score:" . ($score??'null') . "/" . ($evt->target??'null') . " queries:" . ($evt->length()??'null');
			$_this->arr[$_this->length++] = $x2;
		}
	}

	/**
	 * @param string $id
	 * 
	 * @return Requirement
	 */
	public static function load ($id) {
		#src/jotun/gaming/actions/Requirement.hx:20: characters 3-39
		return \Reflect::field(Requirement::$cache, $id);
	}

	/**
	 * @param Requirement $requirement
	 * 
	 * @return void
	 */
	public static function save ($requirement) {
		#src/jotun/gaming/actions/Requirement.hx:16: characters 3-55
		\Reflect::setField(Requirement::$cache, $requirement->id, $requirement);
	}

	/**
	 * @param string $type
	 * @param mixed $data
	 * 
	 * @return void
	 */
	public function __construct ($type, $data) {
		#src/jotun/gaming/actions/Requirement.hx:28: characters 3-20
		parent::__construct($type, $data);
		#src/jotun/gaming/actions/Requirement.hx:29: lines 29-33
		if (Boot::dynamicField($data, 'target') === null) {
			#src/jotun/gaming/actions/Requirement.hx:30: characters 4-21
			$this->target = $this->length();
		} else {
			#src/jotun/gaming/actions/Requirement.hx:32: characters 4-33
			$this->target = (int)(Boot::dynamicField($data, 'target'));
		}
		#src/jotun/gaming/actions/Requirement.hx:34: lines 34-36
		if (Utils::isValid(Boot::dynamicField($data, 'id'))) {
			#src/jotun/gaming/actions/Requirement.hx:35: characters 4-41
			EventController::saveRequirement($this);
		}
	}

	/**
	 * @param IEventContext $context
	 * @param int $position
	 * 
	 * @return bool
	 */
	public function verify ($context, $position) {
		#src/jotun/gaming/actions/Requirement.hx:40: characters 3-23
		$res = true;
		#src/jotun/gaming/actions/Requirement.hx:41: characters 3-22
		$score = 0;
		#src/jotun/gaming/actions/Requirement.hx:42: lines 42-52
		if (Utils::isValid($this->query)) {
			#src/jotun/gaming/actions/Requirement.hx:43: characters 4-63
			$sec = Boot::dynamicField(Requirement::$commands->eventRun($this->query, $context), 'result');
			#src/jotun/gaming/actions/Requirement.hx:44: lines 44-50
			if ($sec !== null) {
				#src/jotun/gaming/actions/Requirement.hx:45: lines 45-49
				Dice::Values($sec, function ($v) use (&$score) {
					#src/jotun/gaming/actions/Requirement.hx:46: lines 46-48
					if (Utils::boolean($v)) {
						#src/jotun/gaming/actions/Requirement.hx:47: characters 7-14
						$score += 1;
					}
				});
			}
			#src/jotun/gaming/actions/Requirement.hx:51: characters 10-25
			$b = $this->target;
			$aNeg = $score < 0;
			$bNeg = $b < 0;
			$res = ($aNeg !== $bNeg ? $aNeg : $score >= $b);
		}
		#src/jotun/gaming/actions/Requirement.hx:53: characters 3-30
		$res = $this->resolve($res, $context);
		#src/jotun/gaming/actions/Requirement.hx:54: lines 54-56
		if ($context->debug) {
			#src/jotun/gaming/actions/Requirement.hx:55: characters 4-54
			Requirement::_log($this, $context, $res, $score, $this->reverse, $position);
		}
		#src/jotun/gaming/actions/Requirement.hx:57: characters 3-13
		return $res;
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
		self::$commands = new RequirementQueryGroup();
	}
}

Boot::registerClass(Requirement::class, 'jotun.gaming.actions.Requirement');
Requirement::__hx__init();
