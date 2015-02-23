package js.three;

import js.html.*;

@:native("THREE.PointCloudMaterial")
extern class PointCloudMaterial extends Material
{
	function new(?parameters:PointCloudMaterialParameters) : Void;

	var color : Color;
	var map : Texture;
	var size : Float;
	var sizeAttenuation : Bool;
	var vertexColors : Bool;
	var fog : Bool;

	@:overload(function():PointCloudMaterial{})
	override function clone(?material:Material) : Material;
}