package js.three;

import js.html.*;

@:native("THREE.RenderableSprite")
extern class RenderableSprite
{
	function new() : Void;

	var id : Int;
	var object : Dynamic;
	var x : Float;
	var y : Float;
	var z : Float;
	var rotation : Float;
	var scale : Vector2;
	var material : Material;
}