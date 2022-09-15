<?php
/**
 */

namespace php\_NativeStructArray;

use \php\Boot;

final class NativeStructArray_Impl_ {
	/**
	 * @param mixed $obj
	 * 
	 * @return array
	 */
	public static function __fromObject ($obj) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/NativeStructArray.hx:34: characters 3-32
		return ((array)($obj));
	}
}

Boot::registerClass(NativeStructArray_Impl_::class, 'php._NativeStructArray.NativeStructArray_Impl_');
