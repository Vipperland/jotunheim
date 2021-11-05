package jotun.math;

/**
 * ...
 * @author 
 */
class MathUtils {

	public static function Sigmoid(x:Float):Float {
		return 1 / (1 + Math.exp( -x));
	}
	
}