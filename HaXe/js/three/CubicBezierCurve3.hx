package js.three;

import js.html.*;

@:native("THREE.CubicBezierCurve3")
extern class CubicBezierCurve3 extends Curve
{
	function new(v0:Vector3, v1:Vector3, v2:Vector3, v3:Vector3) : Void;

	var v0 : Vector3;
	var v1 : Vector3;
	var v2 : Vector3;
	var v3 : Vector3;

	@:overload(function(t:Float):Vector3{})
	override function getPoint(t:Float) : Vector;
}