package js.three;

import js.html.*;

@:native("THREE.HemisphereLight")
extern class HemisphereLight extends Light
{
	function new(?skyColorHex:Int, ?groundColorHex:Int, ?intensity:Float) : Void;

	var groundColor : Color;
	var intensity : Float;

	@:overload(function():HemisphereLight{})
	override function clone(?object:Object3D, ?recursive:Bool) : Object3D;
}