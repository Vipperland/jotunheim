package js.three;

import js.html.*;

@:native("THREE.SpriteCanvasMaterial")
extern class SpriteCanvasMaterial extends Material
{
	function new(?parameters:SpriteCanvasMaterialParameters) : Void;

	var color : Color;

	function program(context:Dynamic, color:Color) : Void;
	@:overload(function():SpriteCanvasMaterial{})
	override function clone(?material:Material) : Material;
}