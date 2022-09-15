<?php
/**
 */

use \php\Boot;

/**
 * The `Lambda` class is a collection of methods to support functional
 * programming. It is ideally used with `using Lambda` and then acts as an
 * extension to Iterable types.
 * On static platforms, working with the Iterable structure might be slower
 * than performing the operations directly on known types, such as Array and
 * List.
 * If the first argument to any of the methods is null, the result is
 * unspecified.
 * @see https://haxe.org/manual/std-Lambda.html
 */
class Lambda {
	/**
	 * Tells if `it` contains an element for which `f` is true.
	 * This function returns true as soon as an element is found for which a
	 * call to `f` returns true.
	 * If no such element is found, the result is false.
	 * If `f` is null, the result is unspecified.
	 * 
	 * @param object $it
	 * @param \Closure $f
	 * 
	 * @return bool
	 */
	public static function exists ($it, $f) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:126: characters 13-15
		$x = $it->iterator();
		while ($x->hasNext()) {
			#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:126: lines 126-128
			$x1 = $x->next();
			#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:127: lines 127-128
			if ($f($x1)) {
				#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:128: characters 5-16
				return true;
			}
		}
		#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:129: characters 3-15
		return false;
	}

	/**
	 * Returns the index of the first element `v` within Iterable `it`.
	 * This function uses operator `==` to check for equality.
	 * If `v` does not exist in `it`, the result is -1.
	 * 
	 * @param object $it
	 * @param mixed $v
	 * 
	 * @return int
	 */
	public static function indexOf ($it, $v) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:236: characters 3-13
		$i = 0;
		#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:237: characters 14-16
		$v2 = $it->iterator();
		while ($v2->hasNext()) {
			#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:237: lines 237-241
			$v21 = $v2->next();
			#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:238: lines 238-239
			if (Boot::equal($v, $v21)) {
				#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:239: characters 5-13
				return $i;
			}
			#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:240: characters 4-7
			++$i;
		}
		#D:\Toolkits\Haxe\4.2.5\haxe\std/Lambda.hx:242: characters 3-12
		return -1;
	}
}

Boot::registerClass(Lambda::class, 'Lambda');
