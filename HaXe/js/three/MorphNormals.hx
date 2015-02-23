package js.three;

import js.html.*;

@:native("THREE.MorphNormals")
extern interface MorphNormals
{
	var name : String;
	var normals : Array<Vector3>;
}