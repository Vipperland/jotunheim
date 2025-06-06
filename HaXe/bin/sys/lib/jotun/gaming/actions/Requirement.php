<?php
/**
 * Generated by Haxe 4.3.6
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
	static public $codex;

	/**
	 * @var int
	 */
	public $target;

	/**
	 * @param Requirement $evt
	 * @param SpellCasting $context
	 * @param bool $success
	 * @param int $score
	 * @param bool $reversed
	 * @param int $position
	 * 
	 * @return void
	 */
	public static function _log ($evt, $context, $success, $score, $reversed, $position) {
		#src/jotun/gaming/actions/Requirement.hx:72: characters 78-128
		$tmp = (Utils::isValid($evt->id) ? "#{" . ($evt->id??'null') . "} " : "");
		#src/jotun/gaming/actions/Requirement.hx:72: characters 3-252
		$context->addLog(0, ((($success ? "└ SUCCESS" : "ꭙ FAILED"))??'null') . " REQUIREMENT " . ($tmp??'null') . "[" . ($position??'null') . "]" . ((($reversed ? " REVERSED" : ""))??'null') . " score:" . ($score??'null') . "/" . ($evt->target??'null') . " queries:" . ($evt->length()??'null'));
	}

	/**
	 * @param string $id
	 * @param mixed[]|\Array_hx $queries
	 * @param mixed $breakon
	 * 
	 * @return mixed
	 */
	public static function createFromQueries ($id, $queries, $breakon = null) {
		#src/jotun/gaming/actions/Requirement.hx:18: characters 3-51
		return new HxAnon([
			"id" => $id,
			"*" => $queries,
			"breakon" => $breakon,
		]);
	}

	/**
	 * @param string $id
	 * 
	 * @return Requirement
	 */
	public static function load ($id) {
		#src/jotun/gaming/actions/Requirement.hx:26: characters 3-39
		return \Reflect::field(Requirement::$cache, $id);
	}

	/**
	 * @param Requirement $requirement
	 * 
	 * @return void
	 */
	public static function save ($requirement) {
		#src/jotun/gaming/actions/Requirement.hx:22: characters 3-55
		\Reflect::setField(Requirement::$cache, $requirement->id, $requirement);
	}

	/**
	 * @param string $type
	 * @param mixed $data
	 * 
	 * @return void
	 */
	public function __construct ($type, $data) {
		#src/jotun/gaming/actions/Requirement.hx:32: characters 3-25
		parent::__construct($type, $data, "*");
		#src/jotun/gaming/actions/Requirement.hx:34: lines 34-38
		if (Boot::dynamicField($data, 'target') === null) {
			#src/jotun/gaming/actions/Requirement.hx:35: characters 4-21
			$this->target = $this->length();
		} else {
			#src/jotun/gaming/actions/Requirement.hx:37: characters 4-33
			$this->target = (int)(Boot::dynamicField($data, 'target'));
		}
		#src/jotun/gaming/actions/Requirement.hx:40: lines 40-42
		if ($this->breakon === null) {
			#src/jotun/gaming/actions/Requirement.hx:41: characters 4-21
			$this->breakon = "never";
		}
		#src/jotun/gaming/actions/Requirement.hx:43: lines 43-45
		if (Utils::isValid(Boot::dynamicField($data, 'id'))) {
			#src/jotun/gaming/actions/Requirement.hx:44: characters 4-36
			SpellCodex::saveRequirement($this);
		}
	}

	/**
	 * @param SpellCasting $context
	 * @param int $position
	 * 
	 * @return bool
	 */
	public function verify ($context, $position) {
		#src/jotun/gaming/actions/Requirement.hx:49: characters 3-12
		$this->connect();
		#src/jotun/gaming/actions/Requirement.hx:50: characters 3-23
		$res = true;
		#src/jotun/gaming/actions/Requirement.hx:51: characters 3-22
		$score = 0;
		#src/jotun/gaming/actions/Requirement.hx:52: lines 52-63
		if (Utils::isValid($this->query)) {
			#src/jotun/gaming/actions/Requirement.hx:53: characters 4-37
			$context->registerRequirement($this);
			#src/jotun/gaming/actions/Requirement.hx:54: characters 4-64
			$sec = Boot::dynamicField(Requirement::$codex->verification($this->query, $context), 'result');
			#src/jotun/gaming/actions/Requirement.hx:55: lines 55-61
			if ($sec !== null) {
				#src/jotun/gaming/actions/Requirement.hx:56: lines 56-60
				Dice::Values($sec, function ($v) use (&$score) {
					#src/jotun/gaming/actions/Requirement.hx:57: lines 57-59
					if (Utils::boolean($v)) {
						#src/jotun/gaming/actions/Requirement.hx:58: characters 7-14
						$score += 1;
					}
				});
			}
			#src/jotun/gaming/actions/Requirement.hx:62: characters 10-25
			$b = $this->target;
			$aNeg = $score < 0;
			$bNeg = $b < 0;
			$res = ($aNeg !== $bNeg ? $aNeg : $score >= $b);
		}
		#src/jotun/gaming/actions/Requirement.hx:64: characters 3-30
		$res = $this->resolve($res, $context);
		#src/jotun/gaming/actions/Requirement.hx:65: lines 65-67
		if ($context->debug) {
			#src/jotun/gaming/actions/Requirement.hx:66: characters 4-54
			Requirement::_log($this, $context, $res, $score, $this->reverse, $position);
		}
		#src/jotun/gaming/actions/Requirement.hx:68: characters 3-13
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
		self::$codex = new RequirementQueryGroup();
	}
}

Boot::registerClass(Requirement::class, 'jotun.gaming.actions.Requirement');
Requirement::__hx__init();
