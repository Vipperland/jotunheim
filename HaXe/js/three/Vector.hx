package js.three;

import js.html.*;

/**
 * (interface Vector&lt;T&gt; )
 *
 * Abstruct interface of Vector2, Vector3 and Vector4.
 * Currently the members of Vector is NOT type safe because it accepts different typed vectors.
 * Those definitions will be changed when TypeScript innovates Generics to be type safe.
 *
 * @example
 * v = new THREE.Vector3();
 * v.addVectors(new THREE.Vector2(0, 1), new THREE.Vector2(2, 3));    // invalid but compiled successfully
 */
@:native("THREE.Vector")
extern interface Vector
{
	function setComponent(index:Int, value:Float) : Void;

	function getComponent(index:Int) : Float;

	/**
	 * copy(v:T) : T;
	 */
	function copy(v:Vector) : Vector;

	/**
	 * add(v:T) : T;
	 */
	function add(v:Vector) : Vector;

	/**
	 * addVectors(a:T, b:T) : T;
	 */
	function addVectors(a:Vector, b:Vector) : Vector;

	/**
	 * sub(v:T) : T;
	 */
	function sub(v:Vector) : Vector;

	/**
	 * subVectors(a:T, b:T) : T;
	 */
	function subVectors(a:Vector, b:Vector) : Vector;

	/**
	 * multiplyScalar(s:Float) : T;
	 */
	function multiplyScalar(s:Float) : Vector;

	/**
	 * divideScalar(s:Float) : T;
	 */
	function divideScalar(s:Float) : Vector;

	/**
	 * negate() : T;
	 */
	function negate() : Vector;

	/**
	 * dot(v:T) : T;
	 */
	function dot(v:Vector) : Float;

	/**
	 * lengthSq() : Float;
	 */
	function lengthSq() : Float;

	/**
	 * length() : Float;
	 */
	function length() : Float;

	/**
	 * normalize() : T;
	 */
	function normalize() : Vector;

	/**
	 * NOTE: Vector4 doesn't have the property.
	 *
	 * distanceTo(v:T) : Float;
	 */
	@:optional function distanceTo(v:Vector) : Float;

	/**
	 * NOTE: Vector4 doesn't have the property.
	 *
	 * distanceToSquared(v:T) : Float;
	 */
	@:optional function distanceToSquared(v:Vector) : Float;

	/**
	 * setLength(l:Float) : T;
	 */
	function setLength(l:Float) : Vector;

	/**
	 * lerp(v:T, alpha:Float) : T;
	 */
	function lerp(v:Vector, alpha:Float) : Vector;

	/**
	 * equals(v:T) : Bool;
	 */
	function equals(v:Vector) : Bool;

	/**
	 * clone() : T;
	 */
	function clone() : Vector;
}