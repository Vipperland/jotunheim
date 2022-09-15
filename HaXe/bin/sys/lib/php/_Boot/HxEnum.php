<?php
/**
 */

namespace php\_Boot;

use \php\Boot;

/**
 * Base class for enum types
 */
class HxEnum {
	/**
	 * @var int
	 */
	public $index;
	/**
	 * @var array
	 */
	public $params;
	/**
	 * @var string
	 */
	public $tag;

	/**
	 * @param string $tag
	 * @param int $index
	 * @param array $arguments
	 * 
	 * @return void
	 */
	public function __construct ($tag, $index, $arguments = null) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/Boot.hx:721: characters 3-17
		$this->tag = $tag;
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/Boot.hx:722: characters 3-21
		$this->index = $index;
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/Boot.hx:723: characters 12-63
		$tmp = null;
		if ($arguments === null) {
			#D:\Toolkits\Haxe\4.2.5\haxe\std/php/Boot.hx:723: characters 33-50
			$this1 = [];
			#D:\Toolkits\Haxe\4.2.5\haxe\std/php/Boot.hx:723: characters 12-63
			$tmp = $this1;
		} else {
			$tmp = $arguments;
		}
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/Boot.hx:723: characters 3-63
		$this->params = $tmp;
	}

	/**
	 * PHP magic method to get string representation of this `Class`
	 * 
	 * @return string
	 */
	public function __toString () {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/Boot.hx:738: characters 3-30
		return Boot::stringify($this);
	}

	/**
	 * Get string representation of this `Class`
	 * 
	 * @return string
	 */
	public function toString () {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/Boot.hx:730: characters 3-22
		return $this->__toString();
	}
}

Boot::registerClass(HxEnum::class, 'php._Boot.HxEnum');
