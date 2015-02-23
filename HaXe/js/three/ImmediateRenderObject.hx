package js.three;

import js.html.*;

@:native("THREE.ImmediateRenderObject")
extern class ImmediateRenderObject extends Object3D
{
	function new() : Void;

	function render(renderCallback:Dynamic) : Void;
}