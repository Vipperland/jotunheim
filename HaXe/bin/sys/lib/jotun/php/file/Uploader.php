<?php
/**
 */

namespace jotun\php\file;

use \jotun\tools\Key;
use \php\Boot;
use \jotun\Jotun;
use \jotun\tools\Utils;
use \jotun\utils\Dice;
use \sys\io\File;
use \php\_Boot\HxString;
use \sys\FileSystem;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Uploader {
	/**
	 * @var string
	 */
	static public $_path = "/";
	/**
	 * @var mixed
	 */
	static public $_sizes;
	/**
	 * @var FileCollection
	 */
	static public $files;

	/**
	 * @param string $file
	 * 
	 * @return string
	 */
	public static function _getType ($file) {
		#src/jotun/php/file/Uploader.hx:56: characters 20-41
		$_this = HxString::split($file, ".");
		if ($_this->length > 0) {
			$_this->length--;
		}
		#src/jotun/php/file/Uploader.hx:56: characters 3-56
		$ext = \mb_strtolower(\array_pop($_this->arr));
		#src/jotun/php/file/Uploader.hx:57: lines 57-60
		if ($ext === "gif" || $ext === "jpeg" || $ext === "jpg" || $ext === "png") {
			#src/jotun/php/file/Uploader.hx:58: characters 39-53
			return "image";
		} else {
			#src/jotun/php/file/Uploader.hx:59: characters 14-31
			return "document";
		}
	}

	/**
	 * @param string $o
	 * @param string $p
	 * 
	 * @return string
	 */
	public static function _rename ($o, $p) {
		#src/jotun/php/file/Uploader.hx:141: characters 3-38
		$n = HxString::split($o, ".");
		#src/jotun/php/file/Uploader.hx:142: characters 5-17
		$tmp = $n->length - 1;
		#src/jotun/php/file/Uploader.hx:142: characters 31-38
		if ($n->length > 0) {
			$n->length--;
		}
		#src/jotun/php/file/Uploader.hx:142: characters 3-38
		$n->offsetSet($tmp, ($p??'null') . "." . (\array_pop($n->arr)??'null'));
		#src/jotun/php/file/Uploader.hx:143: characters 3-21
		return $n->join(".");
	}

	/**
	 * @return void
	 */
	public static function _verify () {
		#src/jotun/php/file/Uploader.hx:65: characters 3-30
		$partName = null;
		#src/jotun/php/file/Uploader.hx:66: characters 3-30
		$lastFile = null;
		#src/jotun/php/file/Uploader.hx:67: characters 3-36
		$fileStream = null;
		#src/jotun/php/file/Uploader.hx:70: lines 70-101
		Jotun::$domain->parseFiles(function ($part, $name) use (&$partName, &$fileStream, &$lastFile) {
			#src/jotun/php/file/Uploader.hx:73: lines 73-93
			if (Utils::isValid($name)) {
				#src/jotun/php/file/Uploader.hx:74: lines 74-90
				if (($name !== null) && ($lastFile !== $name)) {
					#src/jotun/php/file/Uploader.hx:75: characters 7-22
					$partName = $part;
					#src/jotun/php/file/Uploader.hx:76: characters 7-22
					$lastFile = $name;
					#src/jotun/php/file/Uploader.hx:78: lines 78-80
					if ($fileStream !== null) {
						#src/jotun/php/file/Uploader.hx:79: characters 8-26
						$fileStream->close();
					}
					#src/jotun/php/file/Uploader.hx:82: characters 7-40
					$type = Uploader::_getType($name);
					#src/jotun/php/file/Uploader.hx:83: lines 83-89
					if ($type !== null) {
						#src/jotun/php/file/Uploader.hx:85: characters 27-37
						$nName = null;
						if (Jotun::$tick === null) {
							$nName = "null";
						} else {
							$int = Jotun::$tick;
							$nName = \Std::string(($int < 0 ? 4294967296.0 + $int : $int + 0.0));
						}
						#src/jotun/php/file/Uploader.hx:85: characters 27-62
						$nName1 = ($nName??'null') . "_" . (Key::GEN(8)??'null') . ".";
						#src/jotun/php/file/Uploader.hx:85: characters 65-86
						$_this = HxString::split($name, ".");
						if ($_this->length > 0) {
							$_this->length--;
						}
						#src/jotun/php/file/Uploader.hx:85: characters 8-87
						$nName = ($nName1??'null') . (\array_pop($_this->arr)??'null');
						#src/jotun/php/file/Uploader.hx:87: characters 8-52
						$fileStream = File::write((Uploader::$_path??'null') . ($nName??'null'), true);
						#src/jotun/php/file/Uploader.hx:88: characters 8-56
						Uploader::$files->add($part, new FileInfo($type, $name, $nName));
					}
				}
			} else {
				#src/jotun/php/file/Uploader.hx:92: characters 6-23
				$fileStream = null;
			}
		}, function ($bytes, $pos, $len) use (&$fileStream) {
			#src/jotun/php/file/Uploader.hx:97: lines 97-99
			if ($fileStream !== null) {
				#src/jotun/php/file/Uploader.hx:98: characters 6-51
				$fileStream->writeBytes($bytes, 0, $bytes->length);
			}
		});
		#src/jotun/php/file/Uploader.hx:104: lines 104-106
		if ($fileStream !== null) {
			#src/jotun/php/file/Uploader.hx:105: characters 4-22
			$fileStream->close();
		}
		#src/jotun/php/file/Uploader.hx:109: lines 109-136
		if (Uploader::$_sizes !== null) {
			#src/jotun/php/file/Uploader.hx:110: characters 4-35
			$image = new Image();
			#src/jotun/php/file/Uploader.hx:111: lines 111-135
			Dice::Values(Uploader::$files->list, function ($v) use (&$image) {
				#src/jotun/php/file/Uploader.hx:112: lines 112-134
				if ($v->type === "image") {
					#src/jotun/php/file/Uploader.hx:113: characters 6-18
					$v->sizes = new \Array_hx();
					#src/jotun/php/file/Uploader.hx:114: lines 114-129
					Dice::All(Uploader::$_sizes, function ($p, $s) use (&$v, &$image) {
						#src/jotun/php/file/Uploader.hx:115: characters 7-39
						$o = (Uploader::$_path??'null') . ($v->output??'null');
						#src/jotun/php/file/Uploader.hx:116: characters 7-20
						$image->open($o);
						#src/jotun/php/file/Uploader.hx:117: lines 117-128
						if ($image->isOutBounds(Boot::dynamicField($s, 'width'), Boot::dynamicField($s, 'height'))) {
							#src/jotun/php/file/Uploader.hx:119: characters 8-36
							$image->fit(Boot::dynamicField($s, 'width'), Boot::dynamicField($s, 'height'));
							#src/jotun/php/file/Uploader.hx:120: characters 8-25
							$o = Uploader::_rename($o, $p);
							#src/jotun/php/file/Uploader.hx:121: characters 8-21
							$image->save($o);
							#src/jotun/php/file/Uploader.hx:122: characters 8-23
							$_this = $v->sizes;
							$_this->arr[$_this->length++] = $o;
						} else if (Boot::dynamicField($s, 'create')) {
							#src/jotun/php/file/Uploader.hx:125: characters 8-25
							$o = Uploader::_rename($o, $p);
							#src/jotun/php/file/Uploader.hx:126: characters 8-21
							$image->save($o);
							#src/jotun/php/file/Uploader.hx:127: characters 8-23
							$_this = $v->sizes;
							$_this->arr[$_this->length++] = $o;
						}
					});
					#src/jotun/php/file/Uploader.hx:130: lines 130-133
					if ($v->sizes !== null) {
						#src/jotun/php/file/Uploader.hx:131: characters 7-22
						$v->output = null;
						#src/jotun/php/file/Uploader.hx:132: characters 7-21
						$image->delete();
					}
				}
			});
		}
	}

	/**
	 * @param string $q
	 * 
	 * @return void
	 */
	public static function createPath ($q) {
		#src/jotun/php/file/Uploader.hx:29: characters 3-21
		$p = "";
		#src/jotun/php/file/Uploader.hx:30: lines 30-38
		Dice::Values(HxString::split($q, "/"), function ($v) use (&$p) {
			#src/jotun/php/file/Uploader.hx:31: lines 31-37
			if (mb_strlen($v) > 0) {
				#src/jotun/php/file/Uploader.hx:32: characters 5-11
				$p = ($p??'null') . ($v??'null');
				#src/jotun/php/file/Uploader.hx:33: characters 10-30
				\clearstatcache(true, $p);
				#src/jotun/php/file/Uploader.hx:33: lines 33-35
				if (!\file_exists($p) || !FileSystem::isDirectory($p)) {
					#src/jotun/php/file/Uploader.hx:34: characters 6-77
					mkdir($p,0777);
				}
				#src/jotun/php/file/Uploader.hx:36: characters 5-13
				$p = ($p??'null') . "/";
			}
		});
	}

	/**
	 * @param string $path
	 * @param mixed $sizes
	 * 
	 * @return FileCollection
	 */
	public static function save ($path, $sizes = null) {
		#src/jotun/php/file/Uploader.hx:43: lines 43-46
		if (Uploader::$_path !== $path) {
			#src/jotun/php/file/Uploader.hx:44: characters 4-20
			Uploader::createPath($path);
			#src/jotun/php/file/Uploader.hx:45: characters 4-16
			Uploader::$_path = $path;
		}
		#src/jotun/php/file/Uploader.hx:48: lines 48-50
		if ($sizes !== null) {
			#src/jotun/php/file/Uploader.hx:49: characters 4-18
			Uploader::$_sizes = $sizes;
		}
		#src/jotun/php/file/Uploader.hx:51: characters 3-12
		Uploader::_verify();
		#src/jotun/php/file/Uploader.hx:52: characters 3-15
		return Uploader::$files;
	}

	/**
	 * @internal
	 * @access private
	 */
	static public function __hx__init ()
	{
		static $called = false;
		if ($called) return;
		$called = true;


		self::$files = new FileCollection();
	}
}

Boot::registerClass(Uploader::class, 'jotun.php.file.Uploader');
Uploader::__hx__init();
