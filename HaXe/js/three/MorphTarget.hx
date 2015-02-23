package js.three;

import js.html.*;

@:native("THREE.MorphTarget")
extern interface MorphTarget
{
	var name : String;
	var vertices : Array<Vector3>;
}