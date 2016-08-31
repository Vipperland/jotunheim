package sirius.utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Delegate {

	public static function create(handler:Dynamic, ?thisObj:Dynamic, ?args:Array):Dynamic {
		if (args == null) args = [];
		return function() {
			var _a:Array<Dynamic> = untyped __js__('arguments');
			Reflect.callMethod(thisObj, handler, _a.concat(args);
		}
	}
	
}