package js.three;

import js.html.*;

@:native("THREE.Raycaster")
extern class Raycaster
{
	function new(?origin:Vector3, ?direction:Vector3, ?near:Float, ?far:Float) : Void;

	var ray : Ray;
	var near : Float;
	var far : Float;
	var params : RaycasterParameters;
	var precision : Float;
	var linePrecision : Float;
	function set(origin:Vector3, direction:Vector3) : Void;
	function intersectObject(object:Object3D, ?recursive:Bool) : Array<Intersection>;
	function intersectObjects(objects:Array<Object3D>, ?recursive:Bool) : Array<Intersection>;
}