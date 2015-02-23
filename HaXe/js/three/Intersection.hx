package js.three;

import js.html.*;

@:native("THREE.Intersection")
extern interface Intersection
{
	var distance : Float;
	var point : Vector3;
	var face : Face3;
	var object : Object3D;
}