package js.three;

import js.html.*;

@:native("THREE.BoundingBoxHelper")
extern class BoundingBoxHelper extends Mesh
{
	function new(object:Object3D, ?hex:Int) : Void;

	var object : Object3D;
	var box : Array<Box3>;

	function update() : Void;
}