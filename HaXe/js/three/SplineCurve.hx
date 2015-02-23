package js.three;

import js.html.*;

@:native("THREE.SplineCurve")
extern class SplineCurve extends Curve
{
	function new(?points:Array<Vector2>) : Void;

	var points : Array<Vector2>;

	@:overload(function(t:Float):Vector2{})
	override function getPoint(t:Float) : Vector;
}