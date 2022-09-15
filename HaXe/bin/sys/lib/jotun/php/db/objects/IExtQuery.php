<?php
/**
 */

namespace jotun\php\db\objects;

use \php\Boot;

/**
 * @author Rim Project
 */
interface IExtQuery extends IQuery {
	/**
	 * @param \Closure $handler
	 * 
	 * @return void
	 */
	public function each ($handler) ;

	/**
	 * @return mixed
	 */
	public function first () ;

	/**
	 * @return mixed
	 */
	public function last () ;

	/**
	 * @param int $i
	 * 
	 * @return mixed
	 */
	public function one ($i) ;

	/**
	 * @return mixed
	 */
	public function slice () ;
}

Boot::registerClass(IExtQuery::class, 'jotun.php.db.objects.IExtQuery');
