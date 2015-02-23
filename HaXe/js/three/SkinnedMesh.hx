package js.three;

import js.html.*;

@:native("THREE.SkinnedMesh")
extern class SkinnedMesh extends Mesh
{
	@:overload(function(?geometry:Geometry, ?material:MeshDepthMaterial, ?useVertexTexture:Bool):Void{})
	@:overload(function(?geometry:Geometry, ?material:MeshFaceMaterial, ?useVertexTexture:Bool):Void{})
	@:overload(function(?geometry:Geometry, ?material:MeshLambertMaterial, ?useVertexTexture:Bool):Void{})
	@:overload(function(?geometry:Geometry, ?material:MeshNormalMaterial, ?useVertexTexture:Bool):Void{})
	@:overload(function(?geometry:Geometry, ?material:MeshPhongMaterial, ?useVertexTexture:Bool):Void{})
	@:overload(function(?geometry:Geometry, ?material:ShaderMaterial, ?useVertexTexture:Bool):Void{})
	function new(?geometry:Geometry, ?material:MeshBasicMaterial, ?useVertexTexture:Bool) : Void;

	var bindMode : String;
	var bindMatrix : Matrix4;
	var bindMatrixInverse : Matrix4;

	function bind(skeleton:Skeleton, ?bindMatrix:Matrix4) : Void;
	function pose() : Void;
	function normalizeSkinWeights() : Void;
	@:overload(function(?force:Bool):Void{})
	override function updateMatrixWorld(force:Bool) : Void;
	@:overload(function(?object:SkinnedMesh):SkinnedMesh{})
	override function clone(?object:Object3D, ?recursive:Bool) : Object3D;
	
	var skeleton : Skeleton;
}