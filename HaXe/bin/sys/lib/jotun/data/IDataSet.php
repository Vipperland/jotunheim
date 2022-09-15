<?php
/**
 */

namespace jotun\data;

use \php\Boot;

/**
 * @author Rafael Moreira
 */
interface IDataSet {
	/**
	 * Remove all added properties
	 * 
	 * @return IDataSet
	 */
	public function clear () ;

	/**
	 * Inner data content
	 * 
	 * @return mixed
	 */
	public function data () ;

	/**
	 * Shortcut to Dice.All(thisDataSet,handler)
	 * 
	 * @param mixed $handler
	 * 
	 * @return void
	 */
	public function each ($handler) ;

	/**
	 * Check if property exists
	 * 
	 * @param mixed $p
	 * 
	 * @return bool
	 */
	public function exists ($p) ;

	/**
	 * Filter all values and create a new DataSet
	 * 
	 * @param mixed $p
	 * @param mixed $handler
	 * 
	 * @return IDataSet
	 */
	public function filter ($p, $handler = null) ;

	/**
	 * Find all properties with contains a value
	 * 
	 * @param mixed $v
	 * 
	 * @return mixed[]|\Array_hx
	 */
	public function find ($v) ;

	/**
	 * Get property
	 * 
	 * @param mixed $p
	 * 
	 * @return mixed
	 */
	public function get ($p) ;

	/**
	 * All indexes names
	 * 
	 * @return string[]|\Array_hx
	 */
	public function index () ;

	/**
	 * Set property
	 * 
	 * @param mixed $p
	 * @param mixed $v
	 * 
	 * @return IDataSet
	 */
	public function set ($p, $v) ;

	/**
	 * Delete property
	 * 
	 * @param mixed $p
	 * 
	 * @return IDataSet
	 */
	public function unset ($p) ;

	/**
	 * A vector from all values
	 * 
	 * @return mixed[]|\Array_hx
	 */
	public function values () ;
}

Boot::registerClass(IDataSet::class, 'jotun.data.IDataSet');
