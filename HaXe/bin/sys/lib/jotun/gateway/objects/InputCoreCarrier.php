<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace jotun\gateway\objects;

use \php\Boot;
use \jotun\gateway\domain\InputCore;

/**
 * ...
 * @author Rafael Moreira
 */
class InputCoreCarrier {
	/**
	 * @var InputCore
	 */
	public $input;

	/**
	 * @return void
	 */
	public function __construct () {
	}

	/**
	 * @return InputCore
	 */
	public function get_input () {
		#src+extras/gateway/jotun/gateway/objects/InputCoreCarrier.hx:12: characters 3-33
		return InputCore::getInstance();
	}
}

Boot::registerClass(InputCoreCarrier::class, 'jotun.gateway.objects.InputCoreCarrier');
Boot::registerGetters('jotun\\gateway\\objects\\InputCoreCarrier', [
	'input' => true
]);