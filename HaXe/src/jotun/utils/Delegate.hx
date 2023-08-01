package jotun.utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("Delegator")
class Delegate {

	public static function create(handler:Dynamic, context:Dynamic, ...args:Dynamic):Dynamic {
		return function(...args2:Dynamic) {
			Reflect.callMethod(context, handler, (cast args).concat(args2));
		}
	}
	
}