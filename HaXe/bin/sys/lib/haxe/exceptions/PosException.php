<?php
/**
 */

namespace haxe\exceptions;

use \php\_Boot\HxAnon;
use \php\Boot;
use \haxe\Exception;

/**
 * An exception that carry position information of a place where it was created.
 */
class PosException extends Exception {
	/**
	 * @var object
	 * Position where this exception was created.
	 */
	public $posInfos;

	/**
	 * @param string $message
	 * @param Exception $previous
	 * @param object $pos
	 * 
	 * @return void
	 */
	public function __construct ($message, $previous = null, $pos = null) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/exceptions/PosException.hx:13: characters 3-27
		parent::__construct($message, $previous);
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/exceptions/PosException.hx:14: lines 14-18
		if ($pos === null) {
			#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/exceptions/PosException.hx:15: characters 4-100
			$this->posInfos = new _HxAnon_PosException0("(unknown)", 0, "(unknown)", "(unknown)");
		} else {
			#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/exceptions/PosException.hx:17: characters 4-18
			$this->posInfos = $pos;
		}
	}

	/**
	 * Returns exception message.
	 * 
	 * @return string
	 */
	public function toString () {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/exceptions/PosException.hx:25: characters 3-126
		return "" . (parent::toString()??'null') . " in " . ($this->posInfos->className??'null') . "." . ($this->posInfos->methodName??'null') . " at " . ($this->posInfos->fileName??'null') . ":" . ($this->posInfos->lineNumber??'null');
	}

	public function __toString() {
		return $this->toString();
	}
}

class _HxAnon_PosException0 extends HxAnon {
	function __construct($fileName, $lineNumber, $className, $methodName) {
		$this->fileName = $fileName;
		$this->lineNumber = $lineNumber;
		$this->className = $className;
		$this->methodName = $methodName;
	}
}

Boot::registerClass(PosException::class, 'haxe.exceptions.PosException');
