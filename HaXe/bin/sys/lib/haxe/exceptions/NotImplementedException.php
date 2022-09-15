<?php
/**
 */

namespace haxe\exceptions;

use \php\Boot;
use \haxe\Exception;

/**
 * An exception that is thrown when requested function or operation does not have an implementation.
 */
class NotImplementedException extends PosException {
	/**
	 * @param string $message
	 * @param Exception $previous
	 * @param object $pos
	 * 
	 * @return void
	 */
	public function __construct ($message = "Not implemented", $previous = null, $pos = null) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/exceptions/NotImplementedException.hx:8: characters 3-32
		if ($message === null) {
			$message = "Not implemented";
		}
		parent::__construct($message, $previous, $pos);
	}
}

Boot::registerClass(NotImplementedException::class, 'haxe.exceptions.NotImplementedException');
