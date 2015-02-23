package js.three;

import js.html.*;

@:native("THREE.KeyFrames")
extern interface KeyFrames
{
	var keys : Array<KeyFrame>;
	var parent : Float;
}