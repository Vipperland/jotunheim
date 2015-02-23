package js.three;

import js.html.*;

@:native("THREE.MorphAnimation")
extern class MorphAnimation
{
	function new(mesh:Mesh) : Void;

	var mesh : Mesh;
	var frames : Float;
	var currentTime : Float;
	var duration : Float;
	var loop : Bool;
	var isPlaying : Bool;

	function play() : Void;
	function pause() : Void;
	function update(deltaTimeMS:Float) : Void;
}