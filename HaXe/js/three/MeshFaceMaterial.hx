package js.three;

import js.html.*;

// MeshFaceMaterial does not inherit the Material class in the original code. However, it should treat as Material class.
// See tests/canvas/canvas_materials.ts.
@:native("THREE.MeshFaceMaterial")
extern class MeshFaceMaterial extends Material
{
	function new(?materials:Array<Material>) : Void;
	var materials : Array<Material>;

	@:overload(function():MeshFaceMaterial{})
	override function clone(?material:Material) : Material;
}