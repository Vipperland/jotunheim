package jotun.utils;
import php.Syntax;

/**
 * ...
 * @author Rafael Moreira
 */
class SingletonLock {

	private static var _INSTANCES:Dynamic = {};
	
	public static function enforce(Def:Dynamic):Bool {
		return false;
	}
	
}