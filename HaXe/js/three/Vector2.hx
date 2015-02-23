package js.three;

import js.html.*;

/**
 * 2D vector.
 *
 * (class Vector2 implements Vector<Vector2>)
 */
@:native("THREE.Vector2")
extern class Vector2 implements Vector
{
	function new(?x:Float, ?y:Float) : Void;

	var x : Float;
	var y : Float;

	/**
	 * Sets value of this vector.
	 */
	function set(x:Float, y:Float) : Vector2;

	/**
	 * Sets X component of this vector.
	 */
	function setX(x:Float) : Vector2;

	/**
	 * Sets Y component of this vector.
	 */
	function setY(y:Float) : Vector2;

	/**
	 * Sets a component of this vector.
	 */
	function setComponent(index:Int, value:Float) : Void;

	/**
	 * Gets a component of this vector.
	 */
	function getComponent(index:Int) : Float;

	/**
	 * Copies value of v to this vector.
	 */
	@:overload(function(v:Vector2):Vector2{})
	function copy(v:Vector) : Vector;

	/**
	 * Adds v to this vector.
	 */
	@:overload(function(v:Vector2):Vector2{})
	function add(v:Vector) : Vector;

	/**
	 * Sets this vector to a + b.
	 */
	@:overload(function(a:Vector2,b:Vector2):Vector2{})
	function addVectors(a:Vector, b:Vector) : Vector;
	function addScalar(s:Float) : Vector2;

	/**
	 * Subtracts v from this vector.
	 */
	@:overload(function(v:Vector2):Vector2{})
	function sub(v:Vector) : Vector;

	/**
	 * Sets this vector to a - b.
	 */
	@:overload(function(a:Vector2,b:Vector2):Vector2{})
	function subVectors(a:Vector, b:Vector) : Vector;

	function multiply(v:Vector2) : Vector2;
	/**
	 * Multiplies this vector by scalar s.
	 */
	@:overload(function(s:Float):Vector2{})
	function multiplyScalar(s:Float) : Vector;

	function divide(v:Vector2) : Vector2;
	/**
	 * Divides this vector by scalar s.
	 * Set vector to (0, 0) if s == 0.
	 */
	@:overload(function(s:Float):Vector2{})
	function divideScalar(s:Float) : Vector;

	function min(v:Vector2) : Vector2;

	function max(v:Vector2) : Vector2;
	function clamp(min:Vector2, max:Vector2) : Vector2;
	function clampScalar(min:Float, max:Float) : Vector2;
	function floor() : Vector2;
	function ceil() : Vector2;
	function round() : Vector2;
	function roundToZero() : Vector2;

	/**
	 * Inverts this vector.
	 */
	@:overload(function():Vector2{})
	function negate() : Vector;

	/**
	 * Computes dot product of this vector and v.
	 */
	@:overload(function(v:Vector2):Float{})
	function dot(v:Vector) : Float;

	/**
	 * Computes squared length of this vector.
	 */
	function lengthSq() : Float;

	/**
	 * Computes length of this vector.
	 */
	function length() : Float;

	/**
	 * Normalizes this vector.
	 */
	@:overload(function():Vector2{})
	function normalize() : Vector;

	/**
	 * Computes distance of this vector to v.
	 */
	@:overload(function(v:Vector2):Float{})
	function distanceTo(v:Vector) : Float;

	/**
	 * Computes squared distance of this vector to v.
	 */
	@:overload(function(v:Vector2):Float{})
	function distanceToSquared(v:Vector) : Float;

	/**
	 * Normalizes this vector and multiplies it by l.
	 */
	@:overload(function(l:Float):Vector2{})
	function setLength(l:Float) : Vector;

	@:overload(function(v:Vector2,alpha:Float):Vector2{})
	function lerp(v:Vector, alpha:Float) : Vector;
	/**
	 * Checks for strict equality of this vector and v.
	 */
	@:overload(function(v:Vector2):Bool{})
	function equals(v:Vector) : Bool;
	function fromArray(xy:Array<Float>) : Vector2;

	function toArray() : Array<Float>;
	/**
	 * Clones this vector.
	 */
	@:overload(function():Vector2{})
	function clone() : Vector;
}