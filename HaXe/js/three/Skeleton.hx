package js.three;

import js.html.*;

@:native("THREE.Skeleton")
extern class Skeleton
{
	function new(bones:Array<Bone>, ?boneInverses:Array<Matrix4>, ?useVertexTexture:Bool) : Void;

	var useVertexTexture : Bool;
	var identityMatrix : Matrix4;
	var bones : Array<Bone>;
	var boneTextureWidth : Float;
	var boneTextureHeight : Float;
	var boneMatrices : Float32Array;
	var boneTexture : DataTexture;
	var boneInverses : Array<Matrix4>;

	function calculateInverses(bone:Bone) : Void;
	function pose() : Void;
	function update() : Void;
}