package js.three;

import js.html.*;

typedef MeshNormalMaterialParameters =
{
	>MaterialParameters,

	@:optional var shading : Shading;
	@:optional var wireframe : Bool;
	@:optional var wireframeLinewidth : Float;
	@:optional var morphTargets : Bool;
}