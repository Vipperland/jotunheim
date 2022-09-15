<?php
/**
 */

namespace jotun\php\data;

use \php\Boot;

/**
 * ...
 * @author Rafael Moreira
 */
class Cache {
	/**
	 * @return void
	 */
	public function __construct () {
	}

	/**
	 * @param string $name
	 * @param mixed[]|\Array_hx $value
	 * 
	 * @return void
	 */
	public function add ($name, $value) {
		#src/jotun/php/data/Cache.hx:19: lines 19-23
		if ($this->hasField($name)) {
			#src/jotun/php/data/Cache.hx:20: characters 4-57
			\Reflect::setField($this, $name, $this->get($name)->concat($value));
		} else {
			#src/jotun/php/data/Cache.hx:22: characters 4-39
			\Reflect::setField($this, $name, $value);
		}
	}

	/**
	 * @param string $name
	 * 
	 * @return mixed[]|\Array_hx
	 */
	public function get ($name) {
		#src/jotun/php/data/Cache.hx:27: characters 3-35
		return \Reflect::field($this, $name);
	}

	/**
	 * @param string $name
	 * 
	 * @return bool
	 */
	public function hasField ($name) {
		#src/jotun/php/data/Cache.hx:31: characters 3-38
		return \Reflect::hasField($this, $name);
	}

	/**
	 * @param bool $print
	 * @param mixed $encoding
	 * 
	 * @return string
	 */
	public function json ($print = true, $encoding = null) {
		#src/jotun/php/data/Cache.hx:34: lines 34-43
		if ($print === null) {
			$print = true;
		}
		#src/jotun/php/data/Cache.hx:35: characters 3-79
		$result = json_encode($this,256);
		#src/jotun/php/data/Cache.hx:36: lines 36-38
		if ($encoding !== null) {
			#src/jotun/php/data/Cache.hx:37: characters 4-29
			$result = $encoding($result);
		}
		#src/jotun/php/data/Cache.hx:39: lines 39-41
		if ($print) {
			#src/jotun/php/data/Cache.hx:40: characters 4-21
			echo(\Std::string($result));
		}
		#src/jotun/php/data/Cache.hx:42: characters 3-16
		return $result;
	}

	/**
	 * @param string $name
	 * @param mixed[]|\Array_hx $value
	 * 
	 * @return void
	 */
	public function set ($name, $value) {
		#src/jotun/php/data/Cache.hx:15: characters 3-38
		\Reflect::setField($this, $name, $value);
	}
}

Boot::registerClass(Cache::class, 'jotun.php.data.Cache');
