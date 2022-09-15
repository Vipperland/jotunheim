<?php
/**
 */

namespace jotun\data;

use \php\Boot;

/**
 * @author Rafael Moreira
 */
interface IDataCache {
	/**
	 * Convert data to JSON+Base64 encoded
	 * @param	print
	 * @return
	 * 
	 * @param bool $print
	 * 
	 * @return string
	 */
	public function base64 ($print = null) ;

	/**
	 * Clear a property or all data
	 * @param	p
	 * @return
	 * 
	 * @param string $p
	 * 
	 * @return IDataCache
	 */
	public function clear ($p = null) ;

	/**
	 * Check if a property exists
	 * @param	name
	 * @return
	 * 
	 * @param string $name
	 * 
	 * @return bool
	 */
	public function exists ($name = null) ;

	/**
	 * Get a property value
	 * 
	 * @param string $id
	 * 
	 * @return mixed
	 */
	public function get ($id = null) ;

	/**
	 * @return mixed
	 */
	public function get_data () ;

	/**
	 * Convert data to JSON
	 * @param	print
	 * @return
	 * 
	 * @param bool $print
	 * 
	 * @return string
	 */
	public function json ($print = null) ;

	/**
	 * Load data from disk or cookie based on a environment
	 * @return
	 * 
	 * @return bool
	 */
	public function load () ;

	/**
	 * Update object active time
	 * @return
	 * 
	 * @return IDataCache
	 */
	public function refresh () ;

	/**
	 * Write data to disk or cookie based on a environment
	 * @param	base64
	 * @return
	 * 
	 * @return IDataCache
	 */
	public function save () ;

	/**
	 * Set a property value
	 * 
	 * @param string $p
	 * @param mixed $v
	 * 
	 * @return IDataCache
	 */
	public function set ($p, $v) ;
}

Boot::registerClass(IDataCache::class, 'jotun.data.IDataCache');
Boot::registerGetters('jotun\\data\\IDataCache', [
	'data' => true
]);
