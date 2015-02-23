package js.three;

import js.html.*;

/**
 * Represents a spline.
 *
 * @see <a href="https://github.com/mrdoob/three.js/blob/master/src/math/Spline.js">src/math/Spline.js</a>
 */
@:native("THREE.Spline")
extern class Spline
{
	/**
	 * Initialises the spline with points, which are the places through which the spline will go.
	 */
	function new(points:Array<SplineControlPoint>) : Void;

	var points : Array<SplineControlPoint>;

	/**
	 * Initialises using the data in the array as a series of points. Each value in a must be another array with three values, where a[n] is v, the value for the nth point, and v[0], v[1] and v[2] are the x, y and z coordinates of that point n, respectively.
	 *
	 * @param a array of triplets containing x, y, z coordinates
	 */
	function initFromArray(a:Array<Array<Float>>) : Void;

	/**
	 * Return the interpolated point at k.
	 *
	 * @param k point index
	 */
	function getPoint(k:Float) : SplineControlPoint;

	/**
	 * Returns an array with triplets of x, y, z coordinates that correspond to the current control points.
	 */
	function getControlPointsArray() : Array<Array<Float>>;

	/**
	 * Returns the length of the spline when using nSubDivisions.
	 * @param nSubDivisions number of subdivisions between control points. Default is 100.
	 */
	function getLength(?nSubDivisions:Float) : { chunks: Array<Float>, total:Float };

	/**
	 * Modifies the spline so that it looks similar to the original but has its points distributed in such way that moving along the spline it's done at a more or less constant speed. The points should also appear more uniformly spread along the curve.
	 * This is done by resampling the original spline, with the density of sampling controlled by samplingCoef. Here it's interesting to note that denser sampling is not necessarily better: if sampling is too high, you may get weird kinks in curvature.
	 *
	 * @param samplingCoef how many intermediate values to use between spline points
	 */
	function reparametrizeByArcLength(samplingCoef:Float) : Void;
}