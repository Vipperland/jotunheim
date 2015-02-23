package js.three;

import js.html.*;

/**
 * Projects points between spaces.
 */
@:native("THREE.Projector")
extern class Projector
{
	function new() : Void;

	function projectVector(vector:Vector3, camera:Camera) : Vector3;

	function unprojectVector(vector:Vector3, camera:Camera) : Vector3;

	/**
	 * Translates a 2D point from NDC (Normalized Device Coordinates) to a Raycaster that can be used for picking. NDC range from [-1..1] in x (left to right) and [1.0 .. -1.0] in y (top to bottom).
	 */
	function pickingRay(vector:Vector3, camera:Camera) : Raycaster;

	/**
	 * Transforms a 3D scene object into 2D render data that can be rendered in a screen with your renderer of choice, projecting and clipping things out according to the used camera.
	 * If the scene were a real scene, this method would be the equivalent of taking a picture with the camera (and developing the film would be the next step, using a Renderer).
	 *
	 * @param scene scene to project.
	 * @param camera camera to use in the projection.
	 * @param sort select whether to sort elements using the Painter's algorithm.
	 */
	function projectScene(scene:Scene, camera:Camera, sortObjects:Bool, ?sortElements:Bool) : {
		objects : Array<Object3D>,     // Mesh, Line or other object
		sprites : Array<Object3D>,    // Sprite or Particle
		lights : Array<Light>,
		elements : Array<Face3>,    // Line, Particle, Face3 or Face4
	};
}