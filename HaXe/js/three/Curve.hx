package js.three;

import js.html.*;

/**
 * An extensible curve object which contains methods for interpolation
 * class Curve&lt;T extends Vector&gt;
 */
@:native("THREE.Curve")
extern class Curve
{
	/**
	 * Returns a vector for point t of the curve where t is between 0 and 1
	 * getPoint(t:Float) : T;
	 */
	function getPoint(t:Float) : Vector;

	/**
	 * Returns a vector for point at relative position in curve according to arc length
	 * getPointAt(u:Float) : T;
	 */
	function getPointAt(u:Float) : Vector;

	/**
	 * Get sequence of points using getPoint(t)
	 * getPoints(?divisions:Float) : Array<T>;
	 */
	function getPoints(?divisions:Float) : Array<Vector>;

	/**
	 * Get sequence of equi-spaced points using getPointAt(u)
	 * getSpacedPoints(?divisions:Float) : Array<T>;
	 */
	function getSpacedPoints(?divisions:Float) : Array<Vector>;

	/**
	 * Get total curve arc length
	 */
	function getLength() : Float;

	/**
	 * Get list of cumulative segment lengths
	 */
	function getLengths(?divisions:Float) : Array<Float>;

	/**
	 * Update the cumlative segment distance cache
	 */
	function updateArcLengths() : Void;

	/**
	 * Given u (0 .. 1), get a t to find p. This gives you points which are equi distance
	 */
	function getUtoTmapping(u:Float, distance:Float) : Float;

	/**
	 * Returns a unit vector tangent at t. If the subclassed curve do not implement its tangent derivation, 2 points a small delta apart will be used to find its gradient which seems to give a reasonable approximation
	 * getTangent(t:Float) : T;
	 */
	function getTangent(t:Float) : Vector;

	/**
	 * Returns tangent at equidistance point u on the curve
	 * getTangentAt(u:Float) : T;
	 */
	function getTangentAt(u:Float) : Vector;

	static var Utils : {
		function tangentQuadraticBezier(t:Float, p0:Float, p1:Float, p2:Float) : Float;
		function tangentCubicBezier(t:Float, p0:Float, p1:Float, p2:Float, p3:Float) : Float;
		function tangentSpline(t:Float, p0:Float, p1:Float, p2:Float, p3:Float) : Float;
		function interpolate(p0:Float, p1:Float, p2:Float, p3:Float, t:Float) : Float;
	};

	static function create(constructorFunc:Dynamic, getPointFunc:Dynamic) : Dynamic;
}