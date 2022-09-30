<?php
/**
 */

namespace jotun\objects;

use \php\Boot;

/**
 * ...
 * @author Rafael Moreira
 */
class Resolve implements IResolve {
	/**
	 * @param string $name
	 * 
	 * @return void
	 */
	public function deleteProp ($name) {
		#src/jotun/objects/Resolve.hx:18: characters 3-34
		\Reflect::deleteField($this, $name);
	}

	/**
	 * @param string $name
	 * 
	 * @return mixed
	 */
	public function getProp ($name) {
		#src/jotun/objects/Resolve.hx:10: characters 3-35
		return \Reflect::field($this, $name);
	}

	/**
	 * @param string $name
	 * @param mixed $value
	 * 
	 * @return void
	 */
	public function setProp ($name, $value) {
		#src/jotun/objects/Resolve.hx:14: characters 3-38
		\Reflect::setField($this, $name, $value);
	}
}

Boot::registerClass(Resolve::class, 'jotun.objects.Resolve');
