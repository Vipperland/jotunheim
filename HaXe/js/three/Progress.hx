package js.three;

import js.html.*;

@:native("THREE.Progress")
extern interface Progress
{
	var total : Float;
	var loaded : Float;
}