package js.three;

import js.html.*;

typedef PointCloudMaterialParameters =
{
	>MaterialParameters,

	@:optional var color : Int;
	@:optional var map : Texture;
	@:optional var size : Float;
	@:optional var sizeAttenuation : Bool;
	@:optional var vertexColors : Colors;
	@:optional var fog : Bool;
}