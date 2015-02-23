package js.three;

import js.html.*;

@:native("THREE.LineCurve")
extern class LineCurve extends Curve
{
	function new(v1:Vector2, v2:Vector2) : Void;

	var v1 : Vector2;
	var v2 : Vector2;

	@:overload(function(t:Float):Vector2{})
	override function getPoint(t:Float) : Vector;
	@:overload(function(u:Float):Vector2{})
	override function getPointAt(u:Float) : Vector;
	@:overload(function(t:Float):Vector2{})
	override function getTangent(t:Float) : Vector;
}