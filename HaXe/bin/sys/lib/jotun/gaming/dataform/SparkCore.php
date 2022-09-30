<?php
/**
 */

namespace jotun\gaming\dataform;

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\utils\Dice;

/**
 * ...
 * @author
 */
class SparkCore {
	/**
	 * @var string[]|\Array_hx
	 */
	public $_deletions;
	/**
	 * @var mixed
	 */
	public $_indexed;
	/**
	 * @var Spark[]|\Array_hx
	 */
	public $_inserts;
	/**
	 * @var string
	 */
	public $_name;

	/**
	 * @param string $name
	 * 
	 * @return void
	 */
	public function __construct ($name) {
		#src/jotun/gaming/dataform/SparkCore.hx:44: characters 3-15
		$this->_name = $name;
		#src/jotun/gaming/dataform/SparkCore.hx:45: characters 3-16
		$this->_inserts = new \Array_hx();
		#src/jotun/gaming/dataform/SparkCore.hx:46: characters 3-16
		$this->_indexed = new HxAnon();
	}

	/**
	 * @param mixed $id
	 * 
	 * @return Spark
	 */
	public function _delete ($id) {
		#src/jotun/gaming/dataform/SparkCore.hx:30: characters 3-79
		$index = (is_string($id) ? \Reflect::field($this->_indexed, $id) : $id);
		#src/jotun/gaming/dataform/SparkCore.hx:31: lines 31-39
		if ($index !== null) {
			#src/jotun/gaming/dataform/SparkCore.hx:32: characters 4-39
			$object = ($this->_inserts->arr[$index] ?? null);
			#src/jotun/gaming/dataform/SparkCore.hx:33: lines 33-38
			if ($object !== null) {
				#src/jotun/gaming/dataform/SparkCore.hx:34: characters 5-27
				$this->_inserts->offsetSet($index, null);
				#src/jotun/gaming/dataform/SparkCore.hx:35: characters 5-38
				\Reflect::deleteField($this->_indexed, $id);
				#src/jotun/gaming/dataform/SparkCore.hx:36: characters 5-14
				$this->refresh();
				#src/jotun/gaming/dataform/SparkCore.hx:37: characters 5-18
				return $object;
			}
		}
		#src/jotun/gaming/dataform/SparkCore.hx:40: characters 3-14
		return null;
	}

	/**
	 * @param string $pre
	 * 
	 * @return string
	 */
	public function _getDelString ($pre) {
		#src/jotun/gaming/dataform/SparkCore.hx:19: characters 3-23
		$r = null;
		#src/jotun/gaming/dataform/SparkCore.hx:20: lines 20-25
		if (($this->_deletions !== null) && ($this->_deletions->length > 0)) {
			#src/jotun/gaming/dataform/SparkCore.hx:21: characters 4-10
			$r = "";
			#src/jotun/gaming/dataform/SparkCore.hx:22: lines 22-24
			Dice::All($this->_deletions, function ($p, $v) use (&$pre, &$r) {
				#src/jotun/gaming/dataform/SparkCore.hx:23: characters 5-40
				$r = ($r??'null') . ((($p === 0 ? "" : "\x0A"))??'null') . ($pre??'null') . ($v??'null');
			});
		}
		#src/jotun/gaming/dataform/SparkCore.hx:26: characters 3-12
		return $r;
	}

	/**
	 * @param Spark $o
	 * 
	 * @return bool
	 */
	public function canInsert ($o) {
		#src/jotun/gaming/dataform/SparkCore.hx:90: characters 3-14
		return true;
	}

	/**
	 * @param mixed $id
	 * @param bool $silent
	 * 
	 * @return Spark
	 */
	public function delete ($id, $silent = null) {
		#src/jotun/gaming/dataform/SparkCore.hx:132: characters 3-29
		$o = $this->_delete($id);
		#src/jotun/gaming/dataform/SparkCore.hx:133: lines 133-141
		if ($o !== null) {
			#src/jotun/gaming/dataform/SparkCore.hx:134: lines 134-136
			if (!$silent) {
				#src/jotun/gaming/dataform/SparkCore.hx:135: characters 5-61
				$this->_deletions->offsetSet($this->_deletions->length, ($o->getName()??'null') . " " . ($o->id??'null'));
			}
			#src/jotun/gaming/dataform/SparkCore.hx:137: characters 4-15
			$this->onDelete($o);
			#src/jotun/gaming/dataform/SparkCore.hx:138: characters 4-12
			return $o;
		} else {
			#src/jotun/gaming/dataform/SparkCore.hx:140: characters 4-15
			return null;
		}
	}

	/**
	 * @param string $id
	 * 
	 * @return bool
	 */
	public function exists ($id) {
		#src/jotun/gaming/dataform/SparkCore.hx:58: characters 3-40
		return \Reflect::hasField($this->_indexed, $id);
	}

	/**
	 * @param mixed $id
	 * 
	 * @return Spark
	 */
	public function get ($id) {
		#src/jotun/gaming/dataform/SparkCore.hx:62: characters 3-79
		$index = (is_string($id) ? \Reflect::field($this->_indexed, $id) : $id);
		#src/jotun/gaming/dataform/SparkCore.hx:63: lines 63-67
		if ($index !== null) {
			#src/jotun/gaming/dataform/SparkCore.hx:64: characters 4-26
			return ($this->_inserts->arr[$index] ?? null);
		} else {
			#src/jotun/gaming/dataform/SparkCore.hx:66: characters 4-15
			return null;
		}
	}

	/**
	 * @return string
	 */
	public function getName () {
		#src/jotun/gaming/dataform/SparkCore.hx:50: characters 3-15
		return $this->_name;
	}

	/**
	 * Insert ION sub data
	 * @param	name
	 * @param	o
	 * @return
	 * 
	 * @param Spark $o
	 * 
	 * @return bool
	 */
	public function insert ($o) {
		#src/jotun/gaming/dataform/SparkCore.hx:77: lines 77-84
		if ($this->canInsert($o)) {
			#src/jotun/gaming/dataform/SparkCore.hx:78: characters 4-36
			$index = $this->_inserts->length;
			#src/jotun/gaming/dataform/SparkCore.hx:79: characters 4-23
			$this->_inserts->offsetSet($index, $o);
			#src/jotun/gaming/dataform/SparkCore.hx:80: lines 80-82
			if ($o->isIndexable()) {
				#src/jotun/gaming/dataform/SparkCore.hx:81: characters 5-44
				\Reflect::setField($this->_indexed, $o->id, $index);
			}
			#src/jotun/gaming/dataform/SparkCore.hx:83: characters 4-15
			$this->onInsert($o);
		}
		#src/jotun/gaming/dataform/SparkCore.hx:85: characters 3-14
		return true;
	}

	/**
	 * @param string $name
	 * 
	 * @return bool
	 */
	public function is ($name) {
		#src/jotun/gaming/dataform/SparkCore.hx:54: characters 3-23
		return $this->_name === $name;
	}

	/**
	 * @param Spark $o
	 * 
	 * @return void
	 */
	public function onDelete ($o) {
	}

	/**
	 * @param Spark $o
	 * 
	 * @return void
	 */
	public function onInsert ($o) {
	}

	/**
	 * @return void
	 */
	public function onParse () {
	}

	/**
	 * @return void
	 */
	public function refresh () {
		#src/jotun/gaming/dataform/SparkCore.hx:106: characters 3-33
		$max = $this->_inserts->length;
		#src/jotun/gaming/dataform/SparkCore.hx:107: lines 107-128
		if ($max > 0) {
			#src/jotun/gaming/dataform/SparkCore.hx:108: characters 4-22
			$index = 0;
			#src/jotun/gaming/dataform/SparkCore.hx:109: characters 4-23
			$cursor = 0;
			#src/jotun/gaming/dataform/SparkCore.hx:110: characters 4-21
			$object = null;
			#src/jotun/gaming/dataform/SparkCore.hx:111: lines 111-124
			while ($cursor < $max) {
				#src/jotun/gaming/dataform/SparkCore.hx:112: lines 112-122
				if (($this->_inserts->arr[$cursor] ?? null) !== null) {
					#src/jotun/gaming/dataform/SparkCore.hx:113: lines 113-120
					if ($cursor !== $index) {
						#src/jotun/gaming/dataform/SparkCore.hx:114: characters 7-32
						$object = ($this->_inserts->arr[$cursor] ?? null);
						#src/jotun/gaming/dataform/SparkCore.hx:115: characters 7-41
						$this->_inserts->offsetSet($index, ($this->_inserts->arr[$cursor] ?? null));
						#src/jotun/gaming/dataform/SparkCore.hx:116: characters 7-30
						$this->_inserts->offsetSet($cursor, null);
						#src/jotun/gaming/dataform/SparkCore.hx:117: lines 117-119
						if ($object !== null) {
							#src/jotun/gaming/dataform/SparkCore.hx:118: characters 8-52
							\Reflect::setField($this->_indexed, $object->id, $index);
						}
					}
					#src/jotun/gaming/dataform/SparkCore.hx:121: characters 6-16
					++$index;
				}
				#src/jotun/gaming/dataform/SparkCore.hx:123: characters 5-13
				++$cursor;
			}
			#src/jotun/gaming/dataform/SparkCore.hx:125: lines 125-127
			if ($index < $max) {
				#src/jotun/gaming/dataform/SparkCore.hx:126: characters 5-40
				$this->_inserts->splice($index, $max - $index);
			}
		}
	}
}

Boot::registerClass(SparkCore::class, 'jotun.gaming.dataform.SparkCore');
