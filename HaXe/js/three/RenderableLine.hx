package js.three;

import js.html.*;

@:native("THREE.RenderableLine")
extern class RenderableLine
{
	function new() : Void;

	var id : Int;
	var v1 : RenderableVertex;
	var v2 : RenderableVertex;
	var vertexColors : Array<Color>;
	var material : Material;
	var z : Float;
}