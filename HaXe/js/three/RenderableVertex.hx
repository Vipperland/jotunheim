package js.three;

import js.html.*;

@:native("THREE.RenderableVertex")
extern class RenderableVertex
{
	function new() : Void;

	var position : Vector3;
	var positionWorld : Vector3;
	var positionScreen : Vector4;
	var visible : Bool;

	function copy(vertex:RenderableVertex) : Void;
}