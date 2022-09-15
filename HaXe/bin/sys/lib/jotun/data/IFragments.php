<?php
/**
 */

namespace jotun\data;

use \php\Boot;

/**
 * ...
 * @author Rafael Moreira
 */
interface IFragments {
	/**
	 * @param string $value
	 * @param int $at
	 * 
	 * @return IFragments
	 */
	public function addPiece ($value, $at = null) ;

	/**
	 * @return IFragments
	 */
	public function clear () ;

	/**
	 * @param string $value
	 * 
	 * @return bool
	 */
	public function find ($value) ;

	/**
	 * @param int $i
	 * @param int $e
	 * 
	 * @return string
	 */
	public function get ($i, $e = null) ;

	/**
	 * @param string $value
	 * 
	 * @return IFragments
	 */
	public function glue ($value) ;

	/**
	 * @param int $i
	 * @param string $val
	 * 
	 * @return IFragments
	 */
	public function set ($i, $val) ;

	/**
	 * @param string $separator
	 * 
	 * @return IFragments
	 */
	public function split ($separator) ;
}

Boot::registerClass(IFragments::class, 'jotun.data.IFragments');
