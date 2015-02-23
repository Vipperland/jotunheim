package js.three;

import js.html.*;

/**
 * A 4x4 Matrix.
 *
 * @example
 * // Simple rig for rotating around 3 axes
 * var m = new THREE.Matrix4();
 * var m1 = new THREE.Matrix4();
 * var m2 = new THREE.Matrix4();
 * var m3 = new THREE.Matrix4();
 * var alpha = 0;
 * var beta = Math.PI;
 * var gamma = Math.PI/2;
 * m1.makeRotationX(alpha);
 * m2.makeRotationY(beta);
 * m3.makeRotationZ(gamma);
 * m.multiplyMatrices(m1, m2);
 * m.multiply(m3);
 */
@:native("THREE.Matrix4")
extern class Matrix4 implements Matrix
{
	/**
	 * Initialises the matrix with the supplied n11..n44 values.
	 */
	function new(?n11:Float, ?n12:Float, ?n13:Float, ?n14:Float, ?n21:Float, ?n22:Float, ?n23:Float, ?n24:Float, ?n31:Float, ?n32:Float, ?n33:Float, ?n34:Float, ?n41:Float, ?n42:Float, ?n43:Float, ?n44:Float) : Void;

	/**
	 * Float32Array with matrix values.
	 */
	var elements : Float32Array;

	/**
	 * Sets all fields of this matrix.
	 */
	function set(n11:Float, n12:Float, n13:Float, n14:Float, n21:Float, n22:Float, n23:Float, n24:Float, n31:Float, n32:Float, n33:Float, n34:Float, n41:Float, n42:Float, n43:Float, n44:Float) : Matrix4;

	/**
	 * Resets this matrix to identity.
	 */
	@:overload(function():Matrix4{})
	function identity() : Matrix;

	/**
	 * Copies a matrix m into this matrix.
	 */
	@:overload(function(m:Matrix4):Matrix4{})
	function copy(m:Matrix) : Matrix;
	function copyPosition(m:Matrix4) : Matrix4;

	/**
	 * Copies the rotation component of the supplied matrix m into this matrix rotation component.
	 */
	function extractRotation(m:Matrix4) : Matrix4;
	function makeRotationFromEuler(euler:Euler) : Matrix4;
	function makeRotationFromQuaternion(q:Quaternion) : Matrix4;
	/**
	 * Constructs a rotation matrix, looking from eye towards center with defined up vector.
	 */
	function lookAt(eye:Vector3, target:Vector3, up:Vector3) : Matrix4;

	/**
	 * Multiplies this matrix by m.
	 */
	function multiply(m:Matrix4) : Matrix4;

	/**
	 * Sets this matrix to a x b.
	 */
	function multiplyMatrices(a:Matrix4, b:Matrix4) : Matrix4;

	/**
	 * Sets this matrix to a x b and stores the result into the flat array r.
	 * r can be either a regular Array or a TypedArray.
	 */
	function multiplyToArray(a:Matrix4, b:Matrix4, r:Array<Float>) : Matrix4;

	/**
	 * Multiplies this matrix by s.
	 */
	@:overload(function(s:Float):Matrix4{})
	function multiplyScalar(s:Float) : Matrix;
	function applyToVector3Array(array:Array<Float>, ?offset:Float, ?length:Float) : Array<Float>;

	/**
	 * Computes determinant of this matrix.
	 * Based on http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm
	 */
	function determinant() : Float;

	/**
	 * Transposes this matrix.
	 */
	@:overload(function():Matrix4{})
	function transpose() : Matrix;

	/**
	 * Flattens this matrix into supplied flat array starting from offset position in the array.
	 */
	function flattenToArrayOffset(array:Array<Float>, offset:Float) : Array<Float>;

	/**
	 * Sets the position component for this matrix from vector v.
	 */
	function setPosition(v:Vector3) : Vector3;

	/**
	 * Sets this matrix to the inverse of matrix m.
	 * Based on http://www.euclideanspace.com/maths/algebra/matrix/functions/inverse/fourD/index.htm.
	 */
	@:overload(function(m:Matrix4,?throwOnInvertible:Bool):Matrix4{})
	function getInverse(matrix:Matrix, ?throwOnInvertible:Bool) : Matrix;

	/**
	 * Multiplies the columns of this matrix by vector v.
	 */
	function scale(v:Vector3) : Matrix4;

	function getMaxScaleOnAxis() : Float;
	/**
	 * Sets this matrix as translation transform.
	 */
	function makeTranslation(x:Float, y:Float, z:Float) : Matrix4;

	/**
	 * Sets this matrix as rotation transform around x axis by theta radians.
	 *
	 * @param theta Rotation angle in radians.
	 */
	function makeRotationX(theta:Float) : Matrix4;

	/**
	 * Sets this matrix as rotation transform around y axis by theta radians.
	 *
	 * @param theta Rotation angle in radians.
	 */
	function makeRotationY(theta:Float) : Matrix4;

	/**
	 * Sets this matrix as rotation transform around z axis by theta radians.
	 *
	 * @param theta Rotation angle in radians.
	 */
	function makeRotationZ(theta:Float) : Matrix4;

	/**
	 * Sets this matrix as rotation transform around axis by angle radians.
	 * Based on http://www.gamedev.net/reference/articles/article1199.asp.
	 *
	 * @param axis Rotation axis.
	 * @param theta Rotation angle in radians.
	 */
	function makeRotationAxis(axis:Vector3, angle:Float) : Matrix4;

	/**
	 * Sets this matrix as scale transform.
	 */
	function makeScale(x:Float, y:Float, z:Float) : Matrix4;

	/**
	 * Sets this matrix to the transformation composed of translation, rotation and scale.
	 */
	function compose(translation:Vector3, rotation:Quaternion, scale:Vector3) : Matrix4;

	/**
	 * Decomposes this matrix into the translation, rotation and scale components.
	 * If parameters are not passed, new instances will be created.
	 */
	function decompose(?translation:Vector3, ?rotation:Quaternion, ?scale:Vector3) : Array<Dynamic>; // [Vector3, Quaternion, Vector3]

	/**
	 * Creates a frustum matrix.
	 */
	function makeFrustum(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float) : Matrix4;

	/**
	 * Creates a perspective projection matrix.
	 */
	function makePerspective(fov:Float, aspect:Float, near:Float, far:Float) : Matrix4;

	/**
	 * Creates an orthographic projection matrix.
	 */
	function makeOrthographic(left:Float, right:Float, top:Float, bottom:Float, near:Float, far:Float) : Matrix4;
	function fromArray(array:Array<Float>) : Matrix4;
	function toArray() : Array<Float>;
	/**
	 * Clones this matrix.
	 */
	@:overload(function():Matrix4{})
	function clone() : Matrix;
}