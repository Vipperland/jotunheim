package js.three;

import js.html.*;

@:native("THREE.Triangle")
extern class Triangle
{
	function new(?a:Vector3, ?b:Vector3, ?c:Vector3) : Void;

	var a : Vector3;
	var b : Vector3;
	var c : Vector3;

	function set(a:Vector3, b:Vector3, c:Vector3) : Triangle;
	function setFromPointsAndIndices(points:Array<Vector3>, i0:Float, i1:Float, i2:Float) : Triangle;
	function copy(triangle:Triangle) : Triangle;
	function area() : Float;
	function midpoint(?optionalTarget:Vector3) : Vector3;
	function normal(?optionalTarget:Vector3) : Vector3;
	function plane(?optionalTarget:Vector3) : Plane;
	function barycoordFromPoint(point:Vector3, ?optionalTarget:Vector3) : Vector3;
	function containsPoint(point:Vector3) : Bool;
	function equals(triangle:Triangle) : Bool;
	function clone() : Triangle;

	static inline function normal_(a:Vector3, b:Vector3, c:Vector3, ?optionalTarget:Vector3) : Vector3 return untyped js.three.Triangle.normal(a, b, c, optionalTarget);
	static inline function barycoordFromPoint_(point:Vector3, a:Vector3, b:Vector3, c:Vector3, ?optionalTarget:Vector3) : Vector3 return untyped js.three.Triangle.barycoordFromPoint(a, b, c, optionalTarget);
	static inline function containsPoint_(point:Vector3, a:Vector3, b:Vector3, c:Vector3) : Bool return untyped js.three.Triangle.containsPoint(a, b, c);
}