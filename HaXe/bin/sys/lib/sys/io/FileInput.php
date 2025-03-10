<?php
/**
 * Generated by Haxe 4.3.6
 */

namespace sys\io;

use \haxe\io\_BytesData\Container;
use \php\Boot;
use \haxe\Exception;
use \haxe\io\Eof;
use \haxe\io\Error;
use \haxe\io\Input;
use \haxe\io\Bytes;

/**
 * Use `sys.io.File.read` to create a `FileInput`.
 */
class FileInput extends Input {
	/**
	 * @var mixed
	 */
	public $__f;

	/**
	 * @param mixed $f
	 * 
	 * @return void
	 */
	public function __construct ($f) {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:37: characters 3-10
		$this->__f = $f;
	}

	/**
	 * @return void
	 */
	public function close () {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:63: characters 3-16
		parent::close();
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:64: lines 64-65
		if ($this->__f !== null) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:65: characters 4-15
			\fclose($this->__f);
		}
	}

	/**
	 * @return int
	 */
	public function readByte () {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:41: characters 3-25
		$r = \fread($this->__f, 1);
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:42: lines 42-43
		if (\feof($this->__f)) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:43: characters 4-9
			throw Exception::thrown(new Eof());
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:44: lines 44-45
		if ($r === false) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:45: characters 4-9
			throw Exception::thrown(Error::Custom("An error occurred"));
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:46: characters 3-16
		return \ord($r);
	}

	/**
	 * @param Bytes $s
	 * @param int $p
	 * @param int $l
	 * 
	 * @return int
	 */
	public function readBytes ($s, $p, $l) {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:50: lines 50-51
		if (\feof($this->__f)) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:51: characters 4-9
			throw Exception::thrown(new Eof());
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:52: characters 3-25
		$r = \fread($this->__f, $l);
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:53: lines 53-54
		if ($r === false) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:54: characters 4-9
			throw Exception::thrown(Error::Custom("An error occurred"));
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:55: lines 55-56
		if (\strlen($r) === 0) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:56: characters 4-9
			throw Exception::thrown(new Eof());
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:57: characters 11-28
		$b = \strlen($r);
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:57: characters 3-29
		$b1 = new Bytes($b, new Container($r));
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:58: characters 3-29
		$len = \strlen($r);
		if (($p < 0) || ($len < 0) || (($p + $len) > $s->length) || ($len > $b1->length)) {
			throw Exception::thrown(Error::OutsideBounds());
		} else {
			$this1 = $s->b;
			$src = $b1->b;
			$this1->s = ((\substr($this1->s, 0, $p) . \substr($src->s, 0, $len)) . \substr($this1->s, $p + $len));
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/sys/io/FileInput.hx:59: characters 3-19
		return \strlen($r);
	}
}

Boot::registerClass(FileInput::class, 'sys.io.FileInput');
