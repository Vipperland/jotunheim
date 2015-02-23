package js.three;

import js.html.*;

/**
 * (class Matrix3 implements Matrix&lt;Matrix3&gt; )
 */
@:native("THREE.Matrix3")
extern class Matrix3 implements Matrix
{
	/**
	 * Creates an identity matrix.
	 */
	@:overload(function(n11:Float, n12:Float, n13:Float, n21:Float, n22:Float, n23:Float, n31:Float, n32:Float, n33:Float):Void{})
	function new() : Void;

	/**
	 * Initialises the matrix with the supplied n11..n33 values.
	 */

	/**
	 * Float32Array with matrix values.
	 */
	var elements : Float32Array;

	function set(n11:Float, n12:Float, n13:Float, n21:Float, n22:Float, n23:Float, n31:Float, n32:Float, n33:Float) : Matrix3;
	@:overload(function():Matrix3{})
	function identity() : Matrix;
	@:overload(function(m:Matrix3):Matrix3{})
	function copy(m:Matrix) : Matrix;
	function applyToVector3Array(array:Array<Float>, ?offset:Float, ?length:Float) : Array<Float>;
	@:overload(function(s:Float):Matrix3{})
	function multiplyScalar(s:Float) : Matrix;
	function determinant() : Float;
	@:overload(function(matrix:Matrix4,?throwOnInvertible:Bool):Matrix3{})
	@:overload(function(matrix:Matrix3,?throwOnInvertible:Bool):Matrix3{})
	function getInverse(matrix:Matrix, ?throwOnInvertible:Bool) : Matrix;

	/**
	 * Transposes this matrix in place.
	 */
	@:overload(function():Matrix3{})
	function transpose() : Matrix;
	function flattenToArrayOffset(array:Array<Float>, offset:Float) : Array<Float>;
	function getNormalMatrix(m:Matrix4) : Matrix3;

	/**
	 * Transposes this matrix into the supplied array r, and returns itself.
	 */
	function transposeIntoArray(r:Array<Float>) : Array<Float>;
	function fromArray(array:Array<Float>) : Matrix3;
	function toArray() : Array<Float>;
	@:overload(function():Matrix3{})
	function clone() : Matrix;
}