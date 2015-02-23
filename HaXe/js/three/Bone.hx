package js.three;

import js.html.*;

@:native("THREE.Bone")
extern class Bone extends Object3D
{
	function new(belongsToSkin:SkinnedMesh) : Void;

	var skin : SkinnedMesh;

	var accumulatedRotWeight : Float;
	var accumulatedPosWeight : Float;
	var accumulatedSclWeight : Float;

	@:overload(function(?forceUpdate:Bool):Void{})
	override function updateMatrixWorld(force:Bool) : Void;
}