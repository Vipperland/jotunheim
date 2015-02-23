package js.three;

import js.html.*;

@:native("THREE.Math")
extern interface Math
{
	function generateUUID() : String;

	/**
	 * Clamps the x to be between a and b.
	 *
	 * @param x Value to be clamped.
	 * @param a Minimum value
	 * @param b Maximum value.
	 */
	function clamp(x:Float, a:Float, b:Float) : Float;

	/**
	 * Clamps the x to be larger than a.
	 *
	 * @param x — Value to be clamped.
	 * @param a — Minimum value
	 */
	function clampBottom(x:Float, a:Float) : Float;

	/**
	 * Linear mapping of x from range [a1, a2] to range [b1, b2].
	 *
	 * @param x Value to be mapped.
	 * @param a1 Minimum value for range A.
	 * @param a2 Maximum value for range A.
	 * @param b1 Minimum value for range B.
	 * @param b2 Maximum value for range B.
	 */
	function mapLinear(x:Float, a1:Float, a2:Float, b1:Float, b2:Float) : Float;

	function smoothstep(x:Float, min:Float, max:Float) : Float;

	function smootherstep(x:Float, min:Float, max:Float) : Float;

	/**
	 * Random float from 0 to 1 with 16 bits of randomness.
	 * Standard Math.random() creates repetitive patterns when applied over larger space.
	 */
	function random16() : Float;

	/**
	 * Random integer from low to high interval.
	 */
	function randInt(low:Float, high:Float) : Float;

	/**
	 * Random float from low to high interval.
	 */
	function randFloat(low:Float, high:Float) : Float;

	/**
	 * Random float from - range / 2 to range / 2 interval.
	 */
	function randFloatSpread(range:Float) : Float;

	/**
	 * Returns -1 if x is less than 0, 1 if x is greater than 0, and 0 if x is zero.
	 */
	function sign(x:Float) : Float;

	function degToRad(degrees:Float) : Float;

	function radToDeg(radians:Float) : Float;

	function isPowerOfTwo(value:Float) : Bool;
}