<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace jotun\gateway\domain\zones\pass;

use \php\Boot;

/**
 * @author Rafael Moreira
 */
interface IPassCarrier {
	/**
	 * @param int $read
	 * 
	 * @return bool
	 */
	public function canRead ($read) ;

	/**
	 * @param int $write
	 * 
	 * @return bool
	 */
	public function canWrite ($write) ;

	/**
	 * @return mixed
	 */
	public function getInfo () ;
}

Boot::registerClass(IPassCarrier::class, 'jotun.gateway.domain.zones.pass.IPassCarrier');