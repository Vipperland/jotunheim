package js.three;

import js.html.*;

/**
 * Affects objects using MeshLambertMaterial or MeshPhongMaterial.
 *
 * @example
 * // White directional light at half intensity shining from the top.
 * directionalLight = new THREE.DirectionalLight(0xffffff, 0.5);
 * directionalLight.position.set(0, 1, 0);
 * scene.add(directionalLight);
 *
 * @see <a href="https://github.com/mrdoob/three.js/blob/master/src/lights/DirectionalLight.js">src/lights/DirectionalLight.js</a>
 */
@:native("THREE.DirectionalLight")
extern class DirectionalLight extends Light
{
	function new(?hex:Int, ?intensity:Float) : Void;

	/**
	 * Target used for shadow camera orientation.
	 */
	var target : Object3D;

	/**
	 * Light's intensity.
	 * Default — 1.0.
	 */
	var intensity : Float;

	/**
	 * If set to true light will cast dynamic shadows. Warning: This is expensive and requires tweaking to get shadows looking right.
	 * Default — false.
	 */
	//var castShadow : Bool;

	/**
	 * If set to true light will only cast shadow but not contribute any lighting (as if intensity was 0 but cheaper to compute).
	 * Default — false.
	 */
	var onlyShadow : Bool;

	/**
	 * Orthographic shadow camera frustum parameter.
	 * Default — 50.
	 */
	var shadowCameraNear : Float;

	/**
	 * Orthographic shadow camera frustum parameter.
	 * Default — 5000.
	 */
	var shadowCameraFar : Float;

	/**
	 * Orthographic shadow camera frustum parameter.
	 * Default — -500.
	 */
	var shadowCameraLeft : Float;

	/**
	 * Orthographic shadow camera frustum parameter.
	 * Default — 500.
	 */
	var shadowCameraRight : Float;

	/**
	 * Orthographic shadow camera frustum parameter.
	 * Default — 500.
	 */
	var shadowCameraTop : Float;

	/**
	 * Orthographic shadow camera frustum parameter.
	 * Default — -500.
	 */
	var shadowCameraBottom : Float;

	/**
	 * Show debug shadow camera frustum.
	 * Default — false.
	 */
	var shadowCameraVisible : Bool;

	/**
	 * Shadow map bias.
	 * Default — 0.
	 */
	var shadowBias : Float;

	/**
	 * Darkness of shadow casted by this light (from 0 to 1).
	 * Default — 0.5.
	 */
	var shadowDarkness : Float;

	/**
	 * Shadow map texture width in pixels.
	 * Default — 512.
	 */
	var shadowMapWidth : Int;

	/**
	 * Shadow map texture height in pixels.
	 * Default — 512.
	 */
	var shadowMapHeight : Int;

	/**
	 * Default — false.
	 */
	var shadowCascade : Bool;

	/**
	 * Three.Vector3(0, 0, -1000).
	 */
	var shadowCascadeOffset : Vector3;

	/**
	 * Default — 2.
	 */
	var shadowCascadeCount : Int;

	/**
	 * Default — [ 0, 0, 0 ].
	 */
	var shadowCascadeBias : Array<Float>;

	/**
	 * Default — [ 512, 512, 512 ].
	 */
	var shadowCascadeWidth : Array<Float>;

	/**
	 * Default — [ 512, 512, 512 ].
	 */
	var shadowCascadeHeight : Array<Float>;

	/**
	 * Default — [ -1.000, 0.990, 0.998 ].
	 */
	var shadowCascadeNearZ : Array<Float>;

	/**
	 * Default — [ 0.990, 0.998, 1.000 ].
	 */
	var shadowCascadeFarZ : Array<Float>;

	/**
	 * Default — [ ].
	 */
	var shadowCascadeArray : Array<DirectionalLight>;

	/**
	 * Default — null.
	 */
	var shadowMap : RenderTarget;

	/**
	 * Default — null.
	 */
	var shadowMapSize : Float;

	/**
	 * Default — null.
	 */
	var shadowCamera : Camera;

	/**
	 * Default — null.
	 */
	var shadowMatrix : Matrix4;

	@:overload(function():DirectionalLight{})
	override function clone(?object:Object3D, ?recursive:Bool) : Object3D;
}