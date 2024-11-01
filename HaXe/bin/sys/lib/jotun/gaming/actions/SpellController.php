<?php
/**
 * Generated by Haxe 4.3.6
 */

namespace jotun\gaming\actions;

use \php\Boot;

/**
 * ...
 * @author Rim Project
 */
class SpellController implements IEventCollection, IEventDispatcher {
	/**
	 * @var bool
	 */
	static public $_debug;
	/**
	 * @var \Closure
	 */
	static public $_rAction;
	/**
	 * @var \Closure
	 */
	static public $_rRequirement;
	/**
	 * @var \Closure
	 */
	static public $_wAction;
	/**
	 * @var \Closure
	 */
	static public $_wRequirement;

	/**
	 * @var SpellCasting[]|\Array_hx
	 */
	public $_chain;
	/**
	 * @var int
	 */
	public $_index;
	/**
	 * @var mixed
	 */
	public $events;

	/**
	 * @param \Closure $saveAction
	 * @param \Closure $loadAction
	 * @param \Closure $saveRequirement
	 * @param \Closure $loadRequirement
	 * 
	 * @return void
	 */
	public static function cacheController ($saveAction, $loadAction, $saveRequirement, $loadRequirement) {
		#src/jotun/gaming/actions/SpellController.hx:32: characters 3-24
		SpellController::$_wAction = $saveAction;
		#src/jotun/gaming/actions/SpellController.hx:33: characters 3-24
		SpellController::$_rAction = $loadAction;
		#src/jotun/gaming/actions/SpellController.hx:34: characters 3-34
		SpellController::$_wRequirement = $saveRequirement;
		#src/jotun/gaming/actions/SpellController.hx:35: characters 3-34
		SpellController::$_rRequirement = $loadRequirement;
	}

	/**
	 * @param string $name
	 * @param mixed $data
	 * @param IDataProvider $provider
	 * @param SpellController $controller
	 * 
	 * @return SpellCasting
	 */
	public static function createContext ($name, $data, $provider, $controller) {
		#src/jotun/gaming/actions/SpellController.hx:28: characters 3-68
		return new SpellCasting($name, $data, $provider, $controller, SpellController::$_debug);
	}

	/**
	 * @param string $id
	 * 
	 * @return Action
	 */
	public static function loadAction ($id) {
		#src/jotun/gaming/actions/SpellController.hx:39: characters 10-59
		if (SpellController::$_rAction !== null) {
			#src/jotun/gaming/actions/SpellController.hx:39: characters 29-41
			return (SpellController::$_rAction)($id);
		} else {
			#src/jotun/gaming/actions/SpellController.hx:39: characters 44-59
			return Action::load($id);
		}
	}

	/**
	 * @param string $id
	 * 
	 * @return Requirement
	 */
	public static function loadRequirement ($id) {
		#src/jotun/gaming/actions/SpellController.hx:51: characters 10-74
		if (SpellController::$_rRequirement !== null) {
			#src/jotun/gaming/actions/SpellController.hx:51: characters 34-51
			return (SpellController::$_rRequirement)($id);
		} else {
			#src/jotun/gaming/actions/SpellController.hx:51: characters 54-74
			return Requirement::load($id);
		}
	}

	/**
	 * @param Action $a
	 * 
	 * @return void
	 */
	public static function saveAction ($a) {
		#src/jotun/gaming/actions/SpellController.hx:43: lines 43-47
		if (SpellController::$_wAction !== null) {
			#src/jotun/gaming/actions/SpellController.hx:44: characters 4-15
			(SpellController::$_wAction)($a);
		} else {
			#src/jotun/gaming/actions/SpellController.hx:46: characters 4-18
			Action::save($a);
		}
	}

	/**
	 * @param Requirement $r
	 * 
	 * @return void
	 */
	public static function saveRequirement ($r) {
		#src/jotun/gaming/actions/SpellController.hx:55: lines 55-59
		if (SpellController::$_wRequirement !== null) {
			#src/jotun/gaming/actions/SpellController.hx:56: characters 4-20
			(SpellController::$_wRequirement)($r);
		} else {
			#src/jotun/gaming/actions/SpellController.hx:58: characters 4-23
			Requirement::save($r);
		}
	}

	/**
	 * @param mixed $data
	 * @param bool $debug
	 * @param \Closure $validate
	 * @param string[]|\Array_hx $priority
	 * 
	 * @return void
	 */
	public function __construct ($data, $debug = null, $validate = null, $priority = null) {
		#src/jotun/gaming/actions/SpellController.hx:81: characters 43-45
		$this->_chain = new \Array_hx();
		#src/jotun/gaming/actions/SpellController.hx:79: characters 27-28
		$this->_index = 0;
		#src/jotun/gaming/actions/SpellController.hx:71: characters 3-25
		SpellController::$_debug = $debug === true;
		#src/jotun/gaming/actions/SpellController.hx:72: characters 3-50
		$this->events = Spells::patch($data, $validate, $priority);
	}

	/**
	 * @param SpellCasting $context
	 * 
	 * @return void
	 */
	public function _onCallAfter ($context) {
	}

	/**
	 * @param SpellCasting $context
	 * 
	 * @return void
	 */
	public function _onCallBefore ($context) {
	}

	/**
	 * @param SpellCasting[]|\Array_hx $chain
	 * 
	 * @return void
	 */
	public function _onChainEnd ($chain) {
	}

	/**
	 * @param string $name
	 * @param mixed $data
	 * @param IDataProvider $provider
	 * 
	 * @return bool
	 */
	public function call ($name, $data = null, $provider = null) {
		#src/jotun/gaming/actions/SpellController.hx:84: characters 3-72
		$context = SpellController::createContext($name, $data, $provider, $this);
		#src/jotun/gaming/actions/SpellController.hx:85: lines 85-109
		if (\Reflect::hasField($this->events, $name)) {
			#src/jotun/gaming/actions/SpellController.hx:86: characters 4-26
			$context->chain = $this->_index;
			#src/jotun/gaming/actions/SpellController.hx:87: characters 4-35
			$this->_chain->offsetSet($this->_chain->length, $context);
			#src/jotun/gaming/actions/SpellController.hx:88: lines 88-90
			if ($this->_index > 0) {
				#src/jotun/gaming/actions/SpellController.hx:89: characters 5-38
				$context->parent = ($this->_chain->arr[$this->_index - 1] ?? null);
			}
			#src/jotun/gaming/actions/SpellController.hx:91: characters 4-12
			++$this->_index;
			#src/jotun/gaming/actions/SpellController.hx:92: characters 4-26
			$this->_onCallBefore($context);
			#src/jotun/gaming/actions/SpellController.hx:93: characters 4-44
			\Reflect::field($this->events, $name)->run($context);
			#src/jotun/gaming/actions/SpellController.hx:94: characters 4-12
			--$this->_index;
			#src/jotun/gaming/actions/SpellController.hx:95: characters 4-25
			$this->_onCallAfter($context);
			#src/jotun/gaming/actions/SpellController.hx:96: lines 96-100
			if ($this->_index === 0) {
				#src/jotun/gaming/actions/SpellController.hx:97: characters 5-25
				$context->ended = true;
				#src/jotun/gaming/actions/SpellController.hx:98: characters 5-24
				$this->_onChainEnd($this->_chain);
				#src/jotun/gaming/actions/SpellController.hx:99: characters 5-16
				$this->_chain = new \Array_hx();
			}
			#src/jotun/gaming/actions/SpellController.hx:101: characters 4-15
			return true;
		} else {
			#src/jotun/gaming/actions/SpellController.hx:103: lines 103-107
			if (SpellController::$_debug) {
				#src/jotun/gaming/actions/SpellController.hx:104: characters 5-27
				$this->_onCallBefore($context);
				#src/jotun/gaming/actions/SpellController.hx:105: characters 5-112
				$context->addLog(0, "≈ EVENT " . ($name??'null') . " [!] Not Found on " . (\Type::getClassName(\Type::getClass($this))??'null') . ". ");
				#src/jotun/gaming/actions/SpellController.hx:106: characters 5-26
				$this->_onCallAfter($context);
			}
			#src/jotun/gaming/actions/SpellController.hx:108: characters 4-16
			return false;
		}
	}

	/**
	 * @param bool $mode
	 * 
	 * @return void
	 */
	public function setDebug ($mode) {
		#src/jotun/gaming/actions/SpellController.hx:76: characters 3-16
		SpellController::$_debug = $mode;
	}
}

Boot::registerClass(SpellController::class, 'jotun.gaming.actions.SpellController');
