package js.three;

import js.html.*;

@:native("THREE.AnimationData")
extern interface AnimationData
{
	var JIT : Float;
	var fps : Float;
	var hierarchy : Array<KeyFrames>;
	var length : Float;
	var name : String;
}