package js.three;

import js.html.*;

@:native("THREE.Line")
extern class Line extends Object3D
{
	@:overload(function(?geometry:Geometry, ?material:LineBasicMaterial, ?type:Float):Void{})
	@:overload(function(?geometry:Geometry, ?material:ShaderMaterial, ?type:Float):Void{})
	@:overload(function(?geometry:BufferGeometry, ?material:LineDashedMaterial, ?type:Float):Void{})
	@:overload(function(?geometry:BufferGeometry, ?material:LineBasicMaterial, ?type:Float):Void{})
	@:overload(function(?geometry:BufferGeometry, ?material:ShaderMaterial, ?type:Float):Void{})
	function new(?geometry:Geometry, ?material:LineDashedMaterial, ?type:Float) : Void;

	var geometry : Geometry;
	var material : LineBasicMaterial;
	var type : LineType;

	override function raycast(raycaster:Raycaster, intersects:Dynamic) : Void;
	@:overload(function(?object:Line):Line{})
	override function clone(?object:Object3D, ?recursive:Bool) : Object3D;
}