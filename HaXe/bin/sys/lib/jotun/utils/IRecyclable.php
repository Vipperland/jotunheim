<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace jotun\utils;

use \php\Boot;

/**
 * @author Rafael Moreira
 */
interface IRecyclable {
	/**
	 * @param array $rest
	 * 
	 * @return void
	 */
	public function build (...$rest) ;

	/**
	 * @return void
	 */
	public function dispose () ;
}

Boot::registerClass(IRecyclable::class, 'jotun.utils.IRecyclable');