package js.three;

import js.html.*;

/**
 * 4D vector.
 *
 * (class Vector4 implements Vector<Vector4>)
 */
@:native("THREE.Vector4")
extern class Vector4 implements Vector
{
	function new(?x:Float, ?y:Float, ?z:Float, ?w:Float) : Void;
	var x : Float;
	var y : Float;
	var z : Float;
	var w : Float;

	/**
	 * Sets value of this vector.
	 */
	function set(x:Float, y:Float, z:Float, w:Float) : Vector4;

	/**
	 * Sets X component of this vector.
	 */
	function setX(x:Float) : Vector4;

	/**
	 * Sets Y component of this vector.
	 */
	function setY(y:Float) : Vector4;

	/**
	 * Sets Z component of this vector.
	 */
	function setZ(z:Float) : Vector4;

	/**
	 * Sets w component of this vector.
	 */
	function setW(w:Float) : Vector4;

	function setComponent(index:Int, value:Float) : Void;
	function getComponent(index:Int) : Float;

	/**
	 * Copies value of v to this vector.
	 */
	@:overload(function(v:Vector4):Vector4{})
	function copy(v:Vector) : Vector;

	/**
	 * Adds v to this vector.
	 */
	@:overload(function(v:Vector4):Vector4{})
	function add(v:Vector) : Vector;
	function addScalar(s:Float) : Vector4;

	/**
	 * Sets this vector to a + b.
	 */
	@:overload(function(a:Vector4,b:Vector4):Vector4{})
	function addVectors(a:Vector, b:Vector) : Vector;

	/**
	 * Subtracts v from this vector.
	 */
	@:overload(function(v:Vector4):Vector4{})
	function sub(v:Vector) : Vector;

	/**
	 * Sets this vector to a - b.
	 */
	@:overload(function(a:Vector4,b:Vector4):Vector4{})
	function subVectors(a:Vector, b:Vector) : Vector;

	/**
	 * Multiplies this vector by scalar s.
	 */
	@:overload(function(s:Float):Vector4{})
	function multiplyScalar(s:Float) : Vector;
	function applyMatrix4(m:Matrix4) : Vector4;

	/**
	 * Divides this vector by scalar s.
	 * Set vector to (0, 0, 0) if s == 0.
	 */
	@:overload(function(s:Float):Vector4{})
	function divideScalar(s:Float) : Vector;

	/**
	 * http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToAngle/index.htm
	 * @param q is assumed to be normalized
	 */
	function setAxisAngleFromQuaternion(q:Quaternion) : Vector4;

	/**
	 * http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToAngle/index.htm
	 * @param m assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)
	 */
	function setAxisAngleFromRotationMatrix(m:Matrix3) : Vector4;

	function min(v:Vector4) : Vector4;
	function max(v:Vector4) : Vector4;
	function clamp(min:Vector4, max:Vector4) : Vector4;
	function clampScalar(min:Float, max:Float) : Vector4;
	function floor() : Vector4;
	function ceil() : Vector4;
	function round() : Vector4;
	function roundToZero() : Vector4;

	/**
	 * Inverts this vector.
	 */
	@:overload(function():Vector4{})
	function negate() : Vector;

	/**
	 * Computes dot product of this vector and v.
	 */
	@:overload(function(v:Vector4):Float{})
	function dot(v:Vector) : Float;

	/**
	 * Computes squared length of this vector.
	 */
	function lengthSq() : Float;

	/**
	 * Computes length of this vector.
	 */
	function length() : Float;
	function lengthManhattan() : Float;

	/**
	 * Normalizes this vector.
	 */
	@:overload(function():Vector4{})
	function normalize() : Vector;
	/**
	 * Normalizes this vector and multiplies it by l.
	 */
	@:overload(function(l:Float):Vector4{})
	function setLength(l:Float) : Vector;

	/**
	 * Linearly interpolate between this vector and v with alpha factor.
	 */
	@:overload(function(v:Vector4,alpha:Float):Vector4{})
	function lerp(v:Vector, alpha:Float) : Vector;

	/**
	 * Checks for strict equality of this vector and v.
	 */
	@:overload(function(v:Vector4):Bool{})
	function equals(v:Vector) : Bool;

	function fromArray(xyzw:Array<Float>) : Array<Float>;
	function toArray() : Array<Float>;

	/**
	 * Clones this vector.
	 */
	@:overload(function():Vector4{})
	function clone() : Vector;

	/**
	 * Unsupported.
	 */
	function distanceTo(v:Vector) : Float;

	/**
	 * Unsupported.
	 */
	function distanceToSquared(v:Vector) : Float;
}