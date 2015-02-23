package js.three;

import js.html.*;

@:native("THREE.SplineCurve3")
extern class SplineCurve3 extends Curve
{
	function new(?points:Array<Vector3>) : Void;

	var points : Array<Vector3>;

	@:overload(function(t:Float):Vector3{})
	override function getPoint(t:Float) : Vector;
}