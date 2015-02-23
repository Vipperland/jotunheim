package js.three;

import js.html.*;

@:native("THREE.LineCurve3")
extern class LineCurve3 extends Curve
{
	function new(v1:Vector3, v2:Vector3) : Void;

	var v1 : Vector3;
	var v2 : Vector3;

	@:overload(function(t:Float):Vector3{})
	override function getPoint(t:Float) : Vector;
}