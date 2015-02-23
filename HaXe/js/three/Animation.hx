package js.three;

import js.html.*;

@:native("THREE.Animation")
extern class Animation
{
	function new(root:Mesh, data:AnimationData) : Void;

	var root : Mesh;
	var data : AnimationData;
	var hierarchy : Array<Bone>;
	var currentTime : Float;
	var timeScale : Float;
	var isPlaying : Bool;
	var loop : Bool;
	var weight : Float;
	var keyTypes : Array<String>;
	var interpolationType : Int;

	function play(?startTime:Float, ?weight:Float) : Void;
	function stop() : Void;
	function reset() : Void;
	function update(deltaTimeMS:Float) : Void;
	function getNextKeyWith(type:String, h:Float, key:Int) : KeyFrame;
	function getPrevKeyWith(type:String, h:Float, key:Int) : KeyFrame;
}