package js.three;

import js.html.*;

@:native("THREE.BoundingBox3D")
extern interface BoundingBox3D
{
	var min : Vector3;
	var max : Vector3;
}