<?php
/**
 * Generated by Haxe 4.3.6
 */

use \php\_Boot\HxAnon;
use \php\Boot;
use \php\_Boot\HxClass;
use \php\_Boot\HxString;
use \php\_Boot\HxClosure;
use \php\_Boot\HxEnum;

/**
 * The Haxe Reflection API allows retrieval of type information at runtime.
 * This class complements the more lightweight Reflect class, with a focus on
 * class and enum instances.
 * @see https://haxe.org/manual/types.html
 * @see https://haxe.org/manual/std-reflection.html
 */
class Type {
	/**
	 * Returns the class of `o`, if `o` is a class instance.
	 * If `o` is null or of a different type, null is returned.
	 * In general, type parameter information cannot be obtained at runtime.
	 * 
	 * @param mixed $o
	 * 
	 * @return Class
	 */
	public static function getClass ($o) {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:43: lines 43-50
		if (is_object($o) && !($o instanceof HxClass) && !($o instanceof HxEnum)) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:44: characters 4-54
			$cls = Boot::getClass(get_class($o));
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:45: characters 11-45
			if (($o instanceof HxAnon)) {
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:45: characters 29-33
				return null;
			} else {
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:45: characters 36-44
				return $cls;
			}
		} else if (is_string($o)) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:47: characters 4-22
			return Boot::getClass('String');
		} else {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:49: characters 4-15
			return null;
		}
	}

	/**
	 * Returns the name of class `c`, including its path.
	 * If `c` is inside a package, the package structure is returned dot-
	 * separated, with another dot separating the class name:
	 * `pack1.pack2.(...).packN.ClassName`
	 * If `c` is a sub-type of a Haxe module, that module is not part of the
	 * package structure.
	 * If `c` has no package, the class name is returned.
	 * If `c` is null, the result is unspecified.
	 * The class name does not include any type parameters.
	 * 
	 * @param Class $c
	 * 
	 * @return string
	 */
	public static function getClassName ($c) {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:73: lines 73-74
		if ($c === null) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:74: characters 4-15
			return null;
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:75: characters 3-34
		return Boot::getHaxeName($c);
	}

	/**
	 * Returns a list of the instance fields of class `c`, including
	 * inherited fields.
	 * This only includes fields which are known at compile-time. In
	 * particular, using `getInstanceFields(getClass(obj))` will not include
	 * any fields which were added to `obj` at runtime.
	 * The order of the fields in the returned Array is unspecified.
	 * If `c` is null, the result is unspecified.
	 * 
	 * @param Class $c
	 * 
	 * @return string[]|\Array_hx
	 */
	public static function getInstanceFields ($c) {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:193: lines 193-194
		if ($c === null) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:194: characters 4-15
			return null;
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:195: lines 195-199
		if ($c === Boot::getClass('String')) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:196: lines 196-198
			return \Array_hx::wrap([
				"substr",
				"charAt",
				"charCodeAt",
				"indexOf",
				"lastIndexOf",
				"split",
				"toLowerCase",
				"toUpperCase",
				"toString",
				"length",
			]);
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:201: characters 3-67
		$reflection = new \ReflectionClass($c->phpClassName);
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:203: characters 3-35
		$methods = [];
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:204: characters 18-41
		$data = $reflection->getMethods();
		$_g_current = 0;
		$_g_length = count($data);
		$_g_data = $data;
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:204: lines 204-211
		while ($_g_current < $_g_length) {
			$method = $_g_data[$_g_current++];
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:205: lines 205-210
			if (!$method->isStatic()) {
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:206: characters 5-33
				$name = $method->getName();
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:207: lines 207-209
				if (!(($name === "__construct") || (HxString::indexOf($name, "__hx_") === 0))) {
					#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:208: characters 6-30
					array_push($methods, $name);
				}
			}
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:213: characters 3-38
		$properties = [];
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:214: characters 20-46
		$data = $reflection->getProperties();
		$_g_current = 0;
		$_g_length = count($data);
		$_g_data = $data;
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:214: lines 214-221
		while ($_g_current < $_g_length) {
			$property = $_g_data[$_g_current++];
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:215: lines 215-220
			if (!$property->isStatic()) {
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:216: characters 5-35
				$name = $property->getName();
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:217: lines 217-219
				if (!(($name === "__construct") || (HxString::indexOf($name, "__hx_") === 0))) {
					#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:218: characters 6-33
					array_push($properties, $name);
				}
			}
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:222: characters 3-13
		$properties = array_diff($properties, $methods);
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:224: characters 3-56
		$fields = array_merge($properties, $methods);
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:226: characters 3-44
		return \Array_hx::wrap($fields);
	}

	/**
	 * Returns the runtime type of value `v`.
	 * The result corresponds to the type `v` has at runtime, which may vary
	 * per platform. Assumptions regarding this should be minimized to avoid
	 * surprises.
	 * 
	 * @param mixed $v
	 * 
	 * @return \ValueType
	 */
	public static function typeof ($v) {
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:267: lines 267-268
		if ($v === null) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:268: characters 4-16
			return \ValueType::TNull();
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:270: lines 270-282
		if (is_object($v)) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:271: lines 271-272
			if (($v instanceof \Closure) || ($v instanceof HxClosure)) {
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:272: characters 5-21
				return \ValueType::TFunction();
			}
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:273: lines 273-274
			if (($v instanceof \StdClass)) {
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:274: characters 5-19
				return \ValueType::TObject();
			}
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:275: lines 275-276
			if (($v instanceof HxClass)) {
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:276: characters 5-19
				return \ValueType::TObject();
			}
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:278: characters 4-53
			$hxClass = Boot::getClass(get_class($v));
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:279: lines 279-280
			if (($v instanceof HxEnum)) {
				#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:280: characters 5-31
				return \ValueType::TEnum($hxClass);
			}
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:281: characters 4-31
			return \ValueType::TClass($hxClass);
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:284: lines 284-285
		if (is_bool($v)) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:285: characters 4-16
			return \ValueType::TBool();
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:286: lines 286-287
		if (is_int($v)) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:287: characters 4-15
			return \ValueType::TInt();
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:288: lines 288-289
		if (is_float($v)) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:289: characters 4-17
			return \ValueType::TFloat();
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:290: lines 290-291
		if (is_string($v)) {
			#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:291: characters 4-25
			return \ValueType::TClass(Boot::getClass('String'));
		}
		#D:\Devland\Tools\SDK\Haxe\4.3.6\haxe\std/php/_std/Type.hx:293: characters 3-18
		return \ValueType::TUnknown();
	}
}

Boot::registerClass(Type::class, 'Type');
