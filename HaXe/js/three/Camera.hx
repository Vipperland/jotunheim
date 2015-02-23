package js.three;

import js.html.*;

/**
 * Abstract base class for cameras. This class should always be inherited when you build a new camera.
 */
@:native("THREE.Camera")
extern class Camera extends Object3D
{
	/**
	 * This constructor sets following properties to the correct type: matrixWorldInverse, projectionMatrix and projectionMatrixInverse.
	 */
	function new() : Void;

	/**
	 * This is the inverse of matrixWorld. MatrixWorld contains the Matrix which has the world transform of the Camera.
	 */
	var matrixWorldInverse : Matrix4;

	/**
	 * This is the matrix which contains the projection.
	 */
	var projectionMatrix : Matrix4;

	/**
	 * This make the camera look at the vector position in local space.
	 * @param vector point to look at
	 */
	override function lookAt(vector:Vector3) : Void;

	@:overload(function(?camera:Camera):Camera{})
	override function clone(?object:Object3D, ?recursive:Bool) : Object3D;
}