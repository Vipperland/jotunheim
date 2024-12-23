<?php
/**
 * Generated by Haxe 4.3.4
 */

namespace jotun\gaming\actions;

use \php\Boot;

/**
 * ...
 * @author Rim Project
 */
class EventController implements IEventCollection, IEventDispatcher {
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
	 * @var EventContext[]|\Array_hx
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
		#src/jotun/gaming/actions/EventController.hx:32: characters 3-24
		EventController::$_wAction = $saveAction;
		#src/jotun/gaming/actions/EventController.hx:33: characters 3-24
		EventController::$_rAction = $loadAction;
		#src/jotun/gaming/actions/EventController.hx:34: characters 3-34
		EventController::$_wRequirement = $saveRequirement;
		#src/jotun/gaming/actions/EventController.hx:35: characters 3-34
		EventController::$_rRequirement = $loadRequirement;
	}

	/**
	 * @param string $name
	 * @param mixed $data
	 * @param IDataProvider $provider
	 * 
	 * @return EventContext
	 */
	public static function createContext ($name, $data, $provider) {
		#src/jotun/gaming/actions/EventController.hx:28: characters 3-56
		return new EventContext($name, $data, $provider, EventController::$_debug);
	}

	/**
	 * @param string $id
	 * 
	 * @return Action
	 */
	public static function loadAction ($id) {
		#src/jotun/gaming/actions/EventController.hx:39: characters 10-59
		if (EventController::$_rAction !== null) {
			#src/jotun/gaming/actions/EventController.hx:39: characters 29-41
			return (EventController::$_rAction)($id);
		} else {
			#src/jotun/gaming/actions/EventController.hx:39: characters 44-59
			return Action::load($id);
		}
	}

	/**
	 * @param string $id
	 * 
	 * @return Requirement
	 */
	public static function loadRequirement ($id) {
		#src/jotun/gaming/actions/EventController.hx:51: characters 10-74
		if (EventController::$_rRequirement !== null) {
			#src/jotun/gaming/actions/EventController.hx:51: characters 34-51
			return (EventController::$_rRequirement)($id);
		} else {
			#src/jotun/gaming/actions/EventController.hx:51: characters 54-74
			return Requirement::load($id);
		}
	}

	/**
	 * @param Action $a
	 * 
	 * @return void
	 */
	public static function saveAction ($a) {
		#src/jotun/gaming/actions/EventController.hx:43: lines 43-47
		if (EventController::$_wAction !== null) {
			#src/jotun/gaming/actions/EventController.hx:44: characters 4-15
			(EventController::$_wAction)($a);
		} else {
			#src/jotun/gaming/actions/EventController.hx:46: characters 4-18
			Action::save($a);
		}
	}

	/**
	 * @param Requirement $r
	 * 
	 * @return void
	 */
	public static function saveRequirement ($r) {
		#src/jotun/gaming/actions/EventController.hx:55: lines 55-59
		if (EventController::$_wRequirement !== null) {
			#src/jotun/gaming/actions/EventController.hx:56: characters 4-20
			(EventController::$_wRequirement)($r);
		} else {
			#src/jotun/gaming/actions/EventController.hx:58: characters 4-23
			Requirement::save($r);
		}
	}

	/**
	 * @param mixed $data
	 * @param bool $debug
	 * @param \Closure $validate
	 * 
	 * @return void
	 */
	public function __construct ($data, $debug = null, $validate = null) {
		#src/jotun/gaming/actions/EventController.hx:81: characters 43-45
		$this->_chain = new \Array_hx();
		#src/jotun/gaming/actions/EventController.hx:79: characters 27-28
		$this->_index = 0;
		#src/jotun/gaming/actions/EventController.hx:71: characters 3-25
		EventController::$_debug = $debug === true;
		#src/jotun/gaming/actions/EventController.hx:72: characters 3-40
		$this->events = Events::patch($data, $validate);
	}

	/**
	 * @param EventContext $context
	 * 
	 * @return void
	 */
	public function _onCallAfter ($context) {
	}

	/**
	 * @param EventContext $context
	 * 
	 * @return void
	 */
	public function _onCallBefore ($context) {
	}

	/**
	 * @param EventContext[]|\Array_hx $chain
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
		#src/jotun/gaming/actions/EventController.hx:84: characters 3-66
		$context = EventController::createContext($name, $data, $provider);
		#src/jotun/gaming/actions/EventController.hx:85: lines 85-108
		if (\Reflect::hasField($this->events, $name)) {
			#src/jotun/gaming/actions/EventController.hx:86: characters 4-26
			$context->chain = $this->_index;
			#src/jotun/gaming/actions/EventController.hx:87: characters 4-35
			$this->_chain->offsetSet($this->_chain->length, $context);
			#src/jotun/gaming/actions/EventController.hx:88: lines 88-90
			if ($this->_index > 0) {
				#src/jotun/gaming/actions/EventController.hx:89: characters 5-38
				$context->parent = ($this->_chain->arr[$this->_index - 1] ?? null);
			}
			#src/jotun/gaming/actions/EventController.hx:91: characters 4-12
			++$this->_index;
			#src/jotun/gaming/actions/EventController.hx:92: characters 4-26
			$this->_onCallBefore($context);
			#src/jotun/gaming/actions/EventController.hx:93: characters 4-44
			\Reflect::field($this->events, $name)->run($context);
			#src/jotun/gaming/actions/EventController.hx:94: characters 4-12
			--$this->_index;
			#src/jotun/gaming/actions/EventController.hx:95: characters 4-25
			$this->_onCallAfter($context);
			#src/jotun/gaming/actions/EventController.hx:96: lines 96-99
			if ($this->_index === 0) {
				#src/jotun/gaming/actions/EventController.hx:97: characters 5-24
				$this->_onChainEnd($this->_chain);
				#src/jotun/gaming/actions/EventController.hx:98: characters 5-16
				$this->_chain = new \Array_hx();
			}
			#src/jotun/gaming/actions/EventController.hx:100: characters 4-15
			return true;
		} else {
			#src/jotun/gaming/actions/EventController.hx:102: lines 102-106
			if (EventController::$_debug) {
				#src/jotun/gaming/actions/EventController.hx:103: characters 5-27
				$this->_onCallBefore($context);
				#src/jotun/gaming/actions/EventController.hx:104: characters 5-112
				$context->addLog(0, "≈ EVENT " . ($name??'null') . " [!] Not Found on " . (\Type::getClassName(\Type::getClass($this))??'null') . ". ");
				#src/jotun/gaming/actions/EventController.hx:105: characters 5-26
				$this->_onCallAfter($context);
			}
			#src/jotun/gaming/actions/EventController.hx:107: characters 4-16
			return false;
		}
	}

	/**
	 * @param bool $mode
	 * 
	 * @return void
	 */
	public function setDebug ($mode) {
		#src/jotun/gaming/actions/EventController.hx:76: characters 3-16
		EventController::$_debug = $mode;
	}
}

Boot::registerClass(EventController::class, 'jotun.gaming.actions.EventController');
