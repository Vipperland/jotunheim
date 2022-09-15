<?php
/**
 */

namespace jotun\net;

use \php\Boot;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
interface ILoader {
	/**
	 * Load a module not in queue
	 * @param	file
	 * @param	data
	 * @param	handler
	 * 
	 * @param string $file
	 * @param mixed $data
	 * @param \Closure $handler
	 * 
	 * @return void
	 */
	public function module ($file, $data = null, $handler = null) ;

	/**
	 * Call a url
	 * @param	url
	 * @param	data
	 * @param	handler
	 * @param	method
	 * 
	 * @param string $url
	 * @param mixed $data
	 * @param string $method
	 * @param \Closure $handler
	 * @param mixed $headers
	 * 
	 * @return void
	 */
	public function request ($url, $data = null, $method = null, $handler = null, $headers = null) ;
}

Boot::registerClass(ILoader::class, 'jotun.net.ILoader');
