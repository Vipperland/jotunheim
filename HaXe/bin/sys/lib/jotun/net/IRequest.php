<?php
/**
 */

namespace jotun\net;

use \php\Boot;

/**
 * @author Rafael Moreira
 */
interface IRequest {
	/**
	 * @param string $name
	 * 
	 * @return string
	 */
	public function getHeader ($name) ;

	/**
	 * @return mixed
	 */
	public function object () ;
}

Boot::registerClass(IRequest::class, 'jotun.net.IRequest');
