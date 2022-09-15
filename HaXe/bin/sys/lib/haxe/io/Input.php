<?php
/**
 */

namespace haxe\io;

use \php\_Boot\HxAnon;
use \php\Boot;
use \haxe\Exception;
use \haxe\exceptions\NotImplementedException;

/**
 * An Input is an abstract reader. See other classes in the `haxe.io` package
 * for several possible implementations.
 * All functions which read data throw `Eof` when the end of the stream
 * is reached.
 */
class Input {
	/**
	 * Close the input source.
	 * Behaviour while reading after calling this method is unspecified.
	 * 
	 * @return void
	 */
	public function close () {
	}

	/**
	 * Read and return one byte.
	 * 
	 * @return int
	 */
	public function readByte () {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:53: characters 10-15
		throw new NotImplementedException(null, null, new _HxAnon_Input0("haxe/io/Input.hx", 53, "haxe.io.Input", "readByte"));
	}

	/**
	 * Read `len` bytes and write them into `s` to the position specified by `pos`.
	 * Returns the actual length of read data that can be smaller than `len`.
	 * See `readFullBytes` that tries to read the exact amount of specified bytes.
	 * 
	 * @param Bytes $s
	 * @param int $pos
	 * @param int $len
	 * 
	 * @return int
	 */
	public function readBytes ($s, $pos, $len) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:65: characters 3-15
		$k = $len;
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:66: characters 3-69
		$b = $s->b;
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:67: lines 67-68
		if (($pos < 0) || ($len < 0) || (($pos + $len) > $s->length)) {
			#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:68: characters 4-9
			throw Exception::thrown(Error::OutsideBounds());
		}
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:69: lines 69-83
		try {
			#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:70: lines 70-82
			while ($k > 0) {
				#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:74: characters 5-27
				$val = $this->readByte();
				$b->s[$pos] = \chr($val);
				#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:80: characters 5-10
				++$pos;
				#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:81: characters 5-8
				--$k;
			}
		} catch(\Throwable $_g) {
			#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:69: lines 69-83
			if (!(Exception::caught($_g)->unwrap() instanceof Eof)) {
				throw $_g;
			}
		}
		#D:\Toolkits\Haxe\4.2.5\haxe\std/haxe/io/Input.hx:84: characters 3-17
		return $len - $k;
	}
}

class _HxAnon_Input0 extends HxAnon {
	function __construct($fileName, $lineNumber, $className, $methodName) {
		$this->fileName = $fileName;
		$this->lineNumber = $lineNumber;
		$this->className = $className;
		$this->methodName = $methodName;
	}
}

Boot::registerClass(Input::class, 'haxe.io.Input');
