package js.three;

import js.html.*;

@:native("THREE.ExtrudeGeometry")
extern class ExtrudeGeometry extends Geometry
{
	@:overload(function(?shapes:Array<Shape>, ?options:Dynamic):Void{})
	function new(?shape:Shape, ?options:Dynamic) : Void;

	function addShapeList(shapes:Array<Shape>, ?options:Dynamic) : Void;
	function addShape(shape:Shape, ?options:Dynamic) : Void;
}