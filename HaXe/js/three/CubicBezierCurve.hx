package js.three;

import js.html.*;

@:native("THREE.CubicBezierCurve")
extern class CubicBezierCurve extends Curve
{
	function new(v0:Vector2, v1:Vector2, v2:Vector2, v3:Vector2) : Void;

	var v0 : Vector2;
	var v1 : Vector2;
	var v2 : Vector2;
	var v3 : Vector2;

	@:overload(function(t:Float):Vector2{})
	override function getPoint(t:Float) : Vector;
	@:overload(function(t:Float):Vector2{})
	override function getTangent(t:Float) : Vector;
}