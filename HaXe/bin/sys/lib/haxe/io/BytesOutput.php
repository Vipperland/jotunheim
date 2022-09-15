<?php
/**
 */

namespace haxe\io;

use \php\Boot;
use \haxe\Exception;

class BytesOutput extends Output {
	/**
	 * @var BytesBuffer
	 */
	public $b;

	/**
	 * @return void
	 */
	public function __construct () {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/haxe/io/BytesOutput.hx:31: characters 3-24
		$this->b = new BytesBuffer();
	}

	/**
	 * @return Bytes
	 */
	public function getBytes () {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/haxe/io/BytesOutput.hx:44: characters 3-22
		return $this->b->getBytes();
	}

	/**
	 * @param int $c
	 * 
	 * @return void
	 */
	public function writeByte ($c) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/haxe/io/BytesOutput.hx:35: characters 3-15
		$_this = $this->b;
		$_this->b = ($_this->b . \chr($c));
	}

	/**
	 * @param Bytes $buf
	 * @param int $pos
	 * @param int $len
	 * 
	 * @return int
	 */
	public function writeBytes ($buf, $pos, $len) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/haxe/io/BytesOutput.hx:39: characters 3-28
		$_this = $this->b;
		if (($pos < 0) || ($len < 0) || (($pos + $len) > $buf->length)) {
			throw Exception::thrown(Error::OutsideBounds());
		} else {
			$left = $_this->b;
			$this_s = \substr($buf->b->s, $pos, $len);
			$_this->b = ($left . $this_s);
		}
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/haxe/io/BytesOutput.hx:40: characters 3-13
		return $len;
	}
}

Boot::registerClass(BytesOutput::class, 'haxe.io.BytesOutput');
