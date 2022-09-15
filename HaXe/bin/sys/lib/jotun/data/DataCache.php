<?php
/**
 */

namespace jotun\data;

use \jotun\serial\Packager;
use \php\_Boot\HxAnon;
use \jotun\serial\JsonTool;
use \php\Boot;
use \jotun\tools\Utils;
use \jotun\utils\Dice;
use \sys\io\File;
use \haxe\Json;
use \php\_Boot\HxString;
use \sys\FileSystem;

/**
 * ...
 * @author Rafael Moreira
 */
class DataCache implements IDataCache {
	/**
	 * @var mixed
	 */
	public $_DB;
	/**
	 * @var float
	 */
	public $__time__;
	/**
	 * @var bool
	 */
	public $_base64;
	/**
	 * @var int
	 */
	public $_expire;
	/**
	 * @var bool
	 */
	public $_loaded;
	/**
	 * @var string
	 */
	public $_name;
	/**
	 * @var string
	 */
	public $_path;
	/**
	 * @var bool
	 */
	public $_validated;
	/**
	 * @var mixed
	 */
	public $data;

	/**
	 * @param string $name
	 * @param string $path
	 * @param int $expire
	 * @param bool $base64
	 * 
	 * @return void
	 */
	public function __construct ($name = null, $path = null, $expire = 0, $base64 = null) {
		#src/jotun/data/DataCache.hx:26: lines 26-219
		if ($expire === null) {
			$expire = 0;
		}
		#src/jotun/data/DataCache.hx:62: characters 33-38
		$this->_validated = false;
		#src/jotun/data/DataCache.hx:53: characters 3-15
		$this->_name = $name;
		#src/jotun/data/DataCache.hx:54: characters 3-15
		$this->_path = $path;
		#src/jotun/data/DataCache.hx:55: characters 3-19
		$this->_expire = $expire;
		#src/jotun/data/DataCache.hx:56: characters 3-19
		$this->_base64 = $base64;
		#src/jotun/data/DataCache.hx:57: characters 3-10
		$this->clear();
	}

	/**
	 * @return void
	 */
	public function _checkPath () {
		#src/jotun/data/DataCache.hx:65: characters 4-43
		$p = HxString::split($this->_path, "/");
		#src/jotun/data/DataCache.hx:66: lines 66-79
		if ($p->length > 0) {
			#src/jotun/data/DataCache.hx:67: characters 5-30
			$t = new \Array_hx();
			#src/jotun/data/DataCache.hx:68: lines 68-69
			if (($p->arr[0] ?? null) === "") {
				#src/jotun/data/DataCache.hx:68: characters 21-31
				$t->offsetSet(0, "/");
			} else if (($p->arr[0] ?? null) === ".") {
				#src/jotun/data/DataCache.hx:69: characters 27-38
				$t->offsetSet(0, "./");
			}
			#src/jotun/data/DataCache.hx:70: lines 70-78
			Dice::Values($p, function ($v) use (&$t) {
				#src/jotun/data/DataCache.hx:71: lines 71-76
				if (Utils::isValid($v)) {
					#src/jotun/data/DataCache.hx:72: characters 7-22
					$t->offsetSet($t->length, $v);
					#src/jotun/data/DataCache.hx:73: characters 7-22
					$v = $t->join("/");
					#src/jotun/data/DataCache.hx:74: characters 12-32
					\clearstatcache(true, $v);
					#src/jotun/data/DataCache.hx:74: characters 7-63
					if (!\file_exists($v)) {
						#src/jotun/data/DataCache.hx:74: characters 34-63
						FileSystem::createDirectory($v);
					}
					#src/jotun/data/DataCache.hx:75: characters 7-19
					return false;
				}
				#src/jotun/data/DataCache.hx:77: characters 6-17
				return true;
			});
		}
		#src/jotun/data/DataCache.hx:80: characters 4-31
		$this->_name = ($this->_path??'null') . "/" . ($this->_name??'null');
		#src/jotun/data/DataCache.hx:81: characters 4-21
		$this->_validated = true;
	}

	/**
	 * @return mixed
	 */
	public function _fixData () {
		#src/jotun/data/DataCache.hx:85: characters 4-27
		$data = new HxAnon();
		#src/jotun/data/DataCache.hx:86: characters 4-25
		$this->_fixParams($this->_DB, $data);
		#src/jotun/data/DataCache.hx:87: characters 4-18
		\var_dump($data);
		#src/jotun/data/DataCache.hx:88: characters 4-15
		return $data;
	}

	/**
	 * @param mixed $from
	 * @param mixed $data
	 * 
	 * @return void
	 */
	public function _fixParams ($from, $data) {
		#src/jotun/data/DataCache.hx:92: characters 4-18
		$i = null;
		#src/jotun/data/DataCache.hx:93: lines 93-102
		Dice::All($from, function ($p, $v) use (&$data) {
			#src/jotun/data/DataCache.hx:94: lines 94-100
			if ((is_float($v) || is_int($v)) || is_bool($v) || is_string($v) || Boot::isOfType($v, Boot::getClass('Int'))) {
				#src/jotun/data/DataCache.hx:95: characters 6-34
				\Reflect::setField($data, $p, $v);
			} else if (($v instanceof \Array_hx)) {
				#src/jotun/data/DataCache.hx:97: characters 6-27
				$v = $v->arr;
			} else if (Boot::isOfType($v, Boot::getClass('Dynamic'))) {
				#src/jotun/data/DataCache.hx:99: characters 6-41
				$v = ((array)($v));
			}
			#src/jotun/data/DataCache.hx:101: characters 5-33
			\Reflect::setField($data, $p, $v);
		});
	}

	/**
	 * @return float
	 */
	public function _now () {
		#src/jotun/data/DataCache.hx:49: characters 3-30
		return \Date::now()->getTime();
	}

	/**
	 * @param bool $add
	 * 
	 * @return void
	 */
	public function _sign ($add) {
		#src/jotun/data/DataCache.hx:168: lines 168-173
		if ($add) {
			#src/jotun/data/DataCache.hx:169: characters 4-25
			$this->_DB->__time__ = $this->_now();
		} else {
			#src/jotun/data/DataCache.hx:171: characters 4-45
			$this->__time__ = ($this->_expire > 0 ? Boot::dynamicField($this->_DB, '__time__') : 0);
			#src/jotun/data/DataCache.hx:172: characters 4-40
			\Reflect::deleteField($this->_DB, "__time__");
		}
	}

	/**
	 * @param bool $print
	 * 
	 * @return string
	 */
	public function base64 ($print = null) {
		#src/jotun/data/DataCache.hx:214: characters 3-50
		$result = Packager::encodeBase64($this->_DB);
		#src/jotun/data/DataCache.hx:215: characters 3-39
		if ($print) {
			#src/jotun/data/DataCache.hx:215: characters 22-39
			echo(\Std::string($result));
		}
		#src/jotun/data/DataCache.hx:216: characters 3-16
		return $result;
	}

	/**
	 * @param string $p
	 * 
	 * @return IDataCache
	 */
	public function clear ($p = null) {
		#src/jotun/data/DataCache.hx:108: lines 108-118
		if ($p !== null) {
			#src/jotun/data/DataCache.hx:109: characters 4-52
			if ($p !== "__time__") {
				#src/jotun/data/DataCache.hx:109: characters 25-52
				\Reflect::deleteField($this->_DB, $p);
			}
		} else {
			#src/jotun/data/DataCache.hx:111: characters 4-13
			$this->_DB = new HxAnon();
			#src/jotun/data/DataCache.hx:112: characters 4-42
			if ($this->_expire > 0) {
				#src/jotun/data/DataCache.hx:112: characters 21-42
				$this->_DB->__time__ = $this->_now();
			}
			#src/jotun/data/DataCache.hx:116: characters 5-33
			\unlink($this->_path);
		}
		#src/jotun/data/DataCache.hx:119: characters 3-14
		return $this;
	}

	/**
	 * @param string $name
	 * 
	 * @return bool
	 */
	public function exists ($name = null) {
		#src/jotun/data/DataCache.hx:146: lines 146-150
		if ($name !== null) {
			#src/jotun/data/DataCache.hx:147: characters 4-38
			return \Reflect::hasField($this->_DB, $name);
		} else {
			#src/jotun/data/DataCache.hx:149: characters 4-18
			return $this->_loaded;
		}
	}

	/**
	 * @param string $id
	 * 
	 * @return mixed
	 */
	public function get ($id = null) {
		#src/jotun/data/DataCache.hx:137: characters 3-62
		$d = ($id !== null ? \Reflect::field($this->_DB, $id) : null);
		#src/jotun/data/DataCache.hx:138: lines 138-141
		if ($d === null) {
			#src/jotun/data/DataCache.hx:139: characters 4-11
			$d = new HxAnon();
			#src/jotun/data/DataCache.hx:140: characters 4-14
			$this->set($id, $d);
		}
		#src/jotun/data/DataCache.hx:142: characters 3-11
		return $d;
	}

	/**
	 * @return mixed
	 */
	public function get_data () {
		#src/jotun/data/DataCache.hx:45: characters 3-13
		return $this->_DB;
	}

	/**
	 * @param bool $print
	 * 
	 * @return string
	 */
	public function json ($print = null) {
		#src/jotun/data/DataCache.hx:208: characters 3-58
		$result = JsonTool::stringify($this->_DB, null, " ");
		#src/jotun/data/DataCache.hx:209: characters 3-39
		if ($print) {
			#src/jotun/data/DataCache.hx:209: characters 22-39
			echo(\Std::string($result));
		}
		#src/jotun/data/DataCache.hx:210: characters 3-16
		return $result;
	}

	/**
	 * @return bool
	 */
	public function load () {
		#src/jotun/data/DataCache.hx:177: characters 3-13
		$this->_DB = null;
		#src/jotun/data/DataCache.hx:186: characters 4-33
		if (!$this->_validated) {
			#src/jotun/data/DataCache.hx:186: characters 21-33
			$this->_checkPath();
		}
		#src/jotun/data/DataCache.hx:187: characters 8-32
		$path = $this->_name;
		\clearstatcache(true, $path);
		#src/jotun/data/DataCache.hx:187: lines 187-190
		if (\file_exists($path)) {
			#src/jotun/data/DataCache.hx:188: characters 5-44
			$c = File::getContent($this->_name);
			#src/jotun/data/DataCache.hx:189: characters 5-67
			$this->_DB = ($this->_base64 ? Packager::decodeBase64($c, true) : Json::phpJsonDecode($c));
		}
		#src/jotun/data/DataCache.hx:192: lines 192-198
		if (($this->_DB === null) || (($this->_expire !== 0) && ((Boot::dynamicField($this->_DB, '__time__') === null) || (($this->_now() - Boot::dynamicField($this->_DB, '__time__')) >= $this->_expire)))) {
			#src/jotun/data/DataCache.hx:193: characters 4-13
			$this->_DB = new HxAnon();
			#src/jotun/data/DataCache.hx:194: characters 4-19
			$this->_loaded = false;
		} else {
			#src/jotun/data/DataCache.hx:196: characters 4-16
			$this->_sign(false);
			#src/jotun/data/DataCache.hx:197: characters 4-18
			$this->_loaded = true;
		}
		#src/jotun/data/DataCache.hx:199: characters 3-17
		return $this->_loaded;
	}

	/**
	 * @param string $p
	 * @param mixed $v
	 * 
	 * @return IDataCache
	 */
	public function merge ($p, $v) {
		#src/jotun/data/DataCache.hx:128: lines 128-131
		if (($v instanceof \Array_hx) && \Reflect::hasField($this->_DB, $this->_name)) {
			#src/jotun/data/DataCache.hx:129: characters 4-34
			$t = $this->get($p);
			#src/jotun/data/DataCache.hx:130: characters 4-58
			if (($t instanceof \Array_hx)) {
				#src/jotun/data/DataCache.hx:130: characters 32-58
				return $this->set($p, $t->concat($v));
			}
		}
		#src/jotun/data/DataCache.hx:132: characters 3-30
		\Reflect::setField($this->_DB, $p, $v);
		#src/jotun/data/DataCache.hx:133: characters 3-14
		return $this;
	}

	/**
	 * @return DataCache
	 */
	public function refresh () {
		#src/jotun/data/DataCache.hx:203: characters 3-20
		$this->__time__ = $this->_now();
		#src/jotun/data/DataCache.hx:204: characters 3-14
		return $this;
	}

	/**
	 * @return DataCache
	 */
	public function save () {
		#src/jotun/data/DataCache.hx:158: characters 4-73
		$data = ($this->_base64 ? Packager::encodeBase64($this->_DB) : $this->json(false));
		#src/jotun/data/DataCache.hx:159: characters 4-33
		if (!$this->_validated) {
			#src/jotun/data/DataCache.hx:159: characters 21-33
			$this->_checkPath();
		}
		#src/jotun/data/DataCache.hx:160: characters 4-31
		if ($this->_expire > 0) {
			#src/jotun/data/DataCache.hx:160: characters 20-31
			$this->_sign(true);
		}
		#src/jotun/data/DataCache.hx:161: characters 4-33
		File::saveContent($this->_name, $data);
		#src/jotun/data/DataCache.hx:162: characters 4-32
		if ($this->_expire > 0) {
			#src/jotun/data/DataCache.hx:162: characters 20-32
			$this->_sign(false);
		}
		#src/jotun/data/DataCache.hx:164: characters 3-14
		return $this;
	}

	/**
	 * @param string $p
	 * @param mixed $v
	 * 
	 * @return IDataCache
	 */
	public function set ($p, $v) {
		#src/jotun/data/DataCache.hx:123: characters 3-30
		\Reflect::setField($this->_DB, $p, $v);
		#src/jotun/data/DataCache.hx:124: characters 3-14
		return $this;
	}
}

Boot::registerClass(DataCache::class, 'jotun.data.DataCache');
Boot::registerGetters('jotun\\data\\DataCache', [
	'data' => true
]);
