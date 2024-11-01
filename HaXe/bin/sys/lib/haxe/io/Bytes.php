<?php
/**
 * Generated by Haxe 4.3.6
 */

namespace haxe\io;

use \haxe\io\_BytesData\Container;
use \php\Boot;

class Bytes {
	/**
	 * @var Container
	 */
	public $b;
	/**
	 * @var int
	 */
	public $length;

	/**
	 * @param int $length
	 * 
	 * @return Bytes
	 */
	public static function alloc ($length) {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/haxe/io/Bytes.hx:147: characters 3-52
		return new Bytes($length, new Container(\str_repeat(\chr(0), $length)));
	}

	/**
	 * @param int $length
	 * @param Container $b
	 * 
	 * @return void
	 */
	public function __construct ($length, $b) {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/haxe/io/Bytes.hx:34: characters 3-23
		$this->length = $length;
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/haxe/io/Bytes.hx:35: characters 3-13
		$this->b = $b;
	}

	/**
	 * @return string
	 */
	public function toString () {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/haxe/io/Bytes.hx:135: characters 3-11
		return $this->b->s;
	}

	public function __toString() {
		return $this->toString();
	}
}

Boot::registerClass(Bytes::class, 'haxe.io.Bytes');
