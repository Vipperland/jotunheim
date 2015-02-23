package js.three;

import js.html.*;

@:native("THREE.VertexTangentsHelper")
extern class VertexTangentsHelper extends Line
{
	function new(object:Object3D, ?size:Float, ?hex:Int, ?linewidth:Float) : Void;

	var object : Object3D;
	var size : Float;

	function update(?object:Object3D) : Void;
}