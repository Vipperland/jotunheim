package js.three;

import js.html.*;

@:native("THREE.CurvePath")
extern class CurvePath extends Curve
{
	function new() : Void;

	var curves : Array<Curve>;
	var bends : Array<Path>;
	var autoClose : Bool;

	function add(curve:Curve) : Void;
	function checkConnection() : Bool;
	function closePath() : Void;
	override function getPoint(t:Float) : Vector;
	override function getLength() : Float;
	function getCurveLengths() : Array<Float>;
	function getBoundingBox() : BoundingBox;
	function createPointsGeometry(divisions:Float) : Geometry;
	function createSpacedPointsGeometry(divisions:Float) : Geometry;
	function createGeometry(points:Array<Vector2>) : Geometry;
	function addWrapPath(bendpath:Path) : Void;
	function getTransformedPoints(segments:Float, ?bends:Array<Path>) : Array<Vector2>;
	function getTransformedSpacedPoints(segments:Float, ?bends:Array<Path>) : Array<Vector2>;
	function getWrapPoints(oldPts:Array<Vector2>, path:Path) : Array<Vector2>;
}