<?php
/**
 * Generated by Haxe 4.3.4
 */

use \php\_Boot\HxAnon;
use \php\Boot;
use \zones\debug\TestZone;
use \jotun\gateway\domain\SessionDomainCore;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomDomain extends SessionDomainCore {
	/**
	 * @return void
	 */
	public function __construct () {
		#samples/server/CustomDomain.hx:20: characters 3-10
		parent::__construct();
	}

	/**
	 * @return void
	 */
	public function _buildZoneMap () {
		#samples/server/CustomDomain.hx:13: lines 13-15
		$this->_setZoneMap(new HxAnon(["test" => Boot::getClass(TestZone::class)]));
		#samples/server/CustomDomain.hx:16: characters 3-24
		parent::_buildZoneMap();
	}
}

Boot::registerClass(CustomDomain::class, 'CustomDomain');
