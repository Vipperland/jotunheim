package js.three;

import js.html.*;

/**
 * A point light that can cast shadow in one direction.
 *
 * @example
 * // white spotlight shining from the side, casting shadow
 * var spotLight = new THREE.SpotLight(0xffffff);
 * spotLight.position.set(100, 1000, 100);
 * spotLight.castShadow = true;
 * spotLight.shadowMapWidth = 1024;
 * spotLight.shadowMapHeight = 1024;
 * spotLight.shadowCameraNear = 500;
 * spotLight.shadowCameraFar = 4000;
 * spotLight.shadowCameraFov = 30;
 * scene.add(spotLight);
 */
@:native("THREE.SpotLight")
extern class SpotLight extends Light
{
	function new(?hex:Int, ?intensity:Float, ?distance:Float, ?angle:Float, ?exponent:Float) : Void;

	/**
	 * Spotlight focus points at target.position.
	 * Default position — (0,0,0).
	 */
	var target : Object3D;

	/**
	 * Light's intensity.
	 * Default — 1.0.
	 */
	var intensity : Float;

	/**
	 * If non-zero, light will attenuate linearly from maximum intensity at light position down to zero at distance.
	 * Default — 0.0.
	 */
	var distance : Float;

	/*
	 * Maximum extent of the spotlight, in radians, from its direction.
	 * Default — Math.PI/2.
	 */
	var angle : Float;

	/**
	 * Rapidity of the falloff of light from its target direction.
	 * Default — 10.0.
	 */
	var exponent : Float;

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
	 * Perspective shadow camera frustum near parameter.
	 * Default — 50.
	 */
	var shadowCameraNear : Float;

	/**
	 * Perspective shadow camera frustum far parameter.
	 * Default — 5000.
	 */
	var shadowCameraFar : Float;

	/**
	 * Perspective shadow camera frustum field of view parameter.
	 * Default — 50.
	 */
	var shadowCameraFov : Float;

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
	var shadowMapWidth : Float;

	/**
	 * Shadow map texture height in pixels.
	 * Default — 512.
	 */
	var shadowMapHeight : Float;

	var shadowMap : RenderTarget;
	var shadowMapSize : Vector2;
	var shadowCamera : Camera;
	var shadowMatrix : Matrix4;

	@:overload(function():SpotLight{})
	override function clone(?object:Object3D, ?recursive:Bool) : Object3D;
}