<?php
/**
 */

namespace jotun\objects;

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\utils\Dice;

/**
 * ...
 * @author Rim Project
 */
class QueryGroup {
	/**
	 * @var IQuery[]|\Array_hx
	 */
	public $units;

	/**
	 * @return void
	 */
	public function __construct () {
		#src/jotun/objects/QueryGroup.hx:16: characters 3-10
		$this->clear();
	}

	/**
	 * @param IQuery $o
	 * 
	 * @return void
	 */
	public function add ($o) {
		#src/jotun/objects/QueryGroup.hx:20: lines 20-22
		if ($this->units->indexOf($o) === -1) {
			#src/jotun/objects/QueryGroup.hx:21: characters 4-27
			$this->units->offsetSet($this->units->length, $o);
		}
	}

	/**
	 * @return void
	 */
	public function clear () {
		#src/jotun/objects/QueryGroup.hx:33: characters 3-13
		$this->units = new \Array_hx();
	}

	/**
	 * @param IQuery $o
	 * 
	 * @return void
	 */
	public function remove ($o) {
		#src/jotun/objects/QueryGroup.hx:26: characters 3-34
		$iof = $this->units->indexOf($o);
		#src/jotun/objects/QueryGroup.hx:27: lines 27-29
		if ($iof !== -1) {
			#src/jotun/objects/QueryGroup.hx:28: characters 4-24
			$this->units->splice($iof, 1);
		}
	}

	/**
	 * @param mixed $query
	 * 
	 * @return mixed
	 */
	public function run ($query) {
		#src/jotun/objects/QueryGroup.hx:37: characters 3-27
		$result = new HxAnon();
		#src/jotun/objects/QueryGroup.hx:38: lines 38-41
		Dice::Values($this->units, function ($o) use (&$query, &$result) {
			#src/jotun/objects/QueryGroup.hx:39: characters 4-25
			$o->proc($query, $result);
			#src/jotun/objects/QueryGroup.hx:40: characters 4-13
			$o->flush();
		});
		#src/jotun/objects/QueryGroup.hx:42: characters 3-16
		return $result;
	}
}

Boot::registerClass(QueryGroup::class, 'jotun.objects.QueryGroup');
