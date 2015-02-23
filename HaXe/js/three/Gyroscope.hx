package js.three;

import js.html.*;

@:native("THREE.Gyroscope")
extern class Gyroscope extends Object3D
{
	function new() : Void;

	var translationWorld : Vector3;
	var translationObject : Vector3;
	var quaternionWorld : Quaternion;
	var quaternionObject : Quaternion;
	var scaleWorld : Vector3;
	var scaleObject : Vector3;

	@:overload(function(?force:Bool):Void{})
	override function updateMatrixWorld(force:Bool) : Void;
}