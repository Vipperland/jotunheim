package js.three;

import js.html.*;

/**
 * (interface Matrix&lt;T&gt; )
 */
@:native("THREE.Matrix")
extern interface Matrix
{
	/**
	 * Float32Array with matrix values.
	 */
	var elements : Float32Array;

	/**
	 * identity() : T;
	 */
	function identity() : Matrix;

	/**
	 * copy(m:T) : T;
	 */
	function copy(m:Matrix) : Matrix;

	/**
	 * multiplyScalar(s:Float) : T;
	 */
	function multiplyScalar(s:Float) : Matrix;

	function determinant() : Float;

	/**
	 * getInverse(matrix:T, ?throwOnInvertible:Bool) : T;
	 */
	function getInverse(matrix:Matrix, ?throwOnInvertible:Bool) : Matrix;

	/**
	 * transpose() : T;
	 */
	function transpose() : Matrix;

	/**
	 * clone() : T;
	 */
	function clone() : Matrix;
}