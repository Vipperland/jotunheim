package js.three;

import js.html.*;

@:native("THREE.EllipseCurve")
extern class EllipseCurve extends Curve
{
	function new(aX:Float, aY:Float, xRadius:Float, yRadius:Float, aStartAngle:Float, aEndAngle:Float, aClockwise:Bool) : Void;

	var aX : Float;
	var aY : Float;
	var xRadius : Float;
	var yRadius : Float;
	var aStartAngle : Float;
	var aEndAngle : Float;
	var aClockwise : Bool;

	@:overload(function(t:Float):Vector2{})
	override function getPoint(t:Float) : Vector;
}