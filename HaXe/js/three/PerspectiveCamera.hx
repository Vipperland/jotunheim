package js.three;

import js.html.*;

/**
 * Camera with perspective projection.
 *
 * # example
 *     var camera = new THREE.PerspectiveCamera(45, width / height, 1, 1000);
 *     scene.add(camera);
 *
 * @source https://github.com/mrdoob/three.js/blob/master/src/cameras/PerspectiveCamera.js
 */
@:native("THREE.PerspectiveCamera")
extern class PerspectiveCamera extends Camera
{
	/**
	 * @param fov Camera frustum vertical field of view. Default value is 50.
	 * @param aspect Camera frustum aspect ratio. Default value is 1.
	 * @param near Camera frustum near plane. Default value is 0.1.
	 * @param far Camera frustum far plane. Default value is 2000.
	 */
	function new(?fov:Float, ?aspect:Float, ?near:Float, ?far:Float) : Void;

	/**
	 * Camera frustum vertical field of view, from bottom to top of view, in degrees.
	 */
	var fov : Float;

	/**
	 * Camera frustum aspect ratio, window width divided by window height.
	 */
	var aspect : Float;

	/**
	 * Camera frustum near plane.
	 */
	var near : Float;

	/**
	 * Camera frustum far plane.
	 */
	var far : Float;

	/**
	 * Uses focal length (in mm) to estimate and set FOV 35mm (fullframe) camera is used if frame size is not specified.
	 * Formula based on http://www.bobatkins.com/photography/technical/field_of_view.html
	 * @param focalLength focal length
	 * @param frameHeight frame size. Default value is 24.
	 */
	function setLens(focalLength:Float, ?frameHeight:Float) : Void;

	/**
	 * Sets an offset in a larger frustum. This is useful for multi-window or multi-monitor/multi-machine setups.
	 * For example, if you have 3x2 monitors and each monitor is 1920x1080 and the monitors are in grid like this:
	 *
	 *     +---+---+---+
	 *     | A | B | C |
	 *     +---+---+---+
	 *     | D | E | F |
	 *     +---+---+---+
	 *
	 * then for each monitor you would call it like this:
	 *
	 *     var w = 1920;
	 *     var h = 1080;
	 *     var fullWidth = w * 3;
	 *     var fullHeight = h * 2;
	 *
	 *     // A
	 *     camera.setViewOffset(fullWidth, fullHeight, w * 0, h * 0, w, h);
	 *     // B
	 *     camera.setViewOffset(fullWidth, fullHeight, w * 1, h * 0, w, h);
	 *     // C
	 *     camera.setViewOffset(fullWidth, fullHeight, w * 2, h * 0, w, h);
	 *     // D
	 *     camera.setViewOffset(fullWidth, fullHeight, w * 0, h * 1, w, h);
	 *     // E
	 *     camera.setViewOffset(fullWidth, fullHeight, w * 1, h * 1, w, h);
	 *     // F
	 *     camera.setViewOffset(fullWidth, fullHeight, w * 2, h * 1, w, h); Note there is no reason monitors have to be the same size or in a grid.
	 *
	 * @param fullWidth full width of multiview setup
	 * @param fullHeight full height of multiview setup
	 * @param x horizontal offset of subcamera
	 * @param y vertical offset of subcamera
	 * @param width width of subcamera
	 * @param height height of subcamera
	 */
	function setViewOffset(fullWidth:Float, fullHeight:Float, x:Float, y:Float, width:Float, height:Float) : Void;

	/**
	 * Updates the camera projection matrix. Must be called after change of parameters.
	 */
	function updateProjectionMatrix() : Void;
	@:overload(function():PerspectiveCamera{})
	override function clone(?object:Object3D, ?recursive:Bool) : Object3D;
}