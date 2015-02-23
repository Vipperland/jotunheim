package js.three;

import js.html.*;

@:native("THREE.KeyFrame")
extern interface KeyFrame
{
	var pos : Array<Float>;
	var rot : Array<Float>;
	var scl : Array<Float>;
	var time : Float;
}