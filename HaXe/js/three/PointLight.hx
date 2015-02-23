package js.three;

import js.html.*;

/**
 * Affects objects using {@link MeshLambertMaterial } or {@link MeshPhongMaterial }.
 *
 * @example
 * var light = new THREE.PointLight(0xff0000, 1, 100);
 * light.position.set(50, 50, 50);
 * scene.add(light);
 */
@:native("THREE.PointLight")
extern class PointLight extends Light
{
	function new(?hex:Int, ?intensity:Float, ?distance:Float) : Void;

	/*
	 * Light's intensity.
	 * Default - 1.0.
	 */
	var intensity : Float;

	/**
	 * If non-zero, light will attenuate linearly from maximum intensity at light position down to zero at distance.
	 * Default — 0.0.
	 */
	var distance : Float;

	@:overload(function():PointLight{})
	override function clone(?object:Object3D, ?recursive:Bool) : Object3D;
}