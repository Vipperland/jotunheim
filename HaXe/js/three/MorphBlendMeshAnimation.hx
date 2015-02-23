package js.three;

import js.html.*;

@:native("THREE.MorphBlendMeshAnimation")
extern interface MorphBlendMeshAnimation
{
	var startFrame : Float;
	var endFrame : Float;
	var length : Float;
	var fps : Float;
	var duration : Float;
	var lastFrame : Float;
	var currentFrame : Float;
	var active : Bool;
	var time : Float;
	var direction : Float;
	var weight : Float;
	var directionBackwards : Bool;
	var mirroredLoop : Bool;
}