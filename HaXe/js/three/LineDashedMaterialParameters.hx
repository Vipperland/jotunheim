package js.three;

import js.html.*;

typedef LineDashedMaterialParameters =
{
	>MaterialParameters,

	@:optional var color : Int;
	@:optional var linewidth : Float;
	@:optional var scale : Float;
	@:optional var dashSize : Float;
	@:optional var gapSize : Float;
	@:optional var vertexColors : Colors;
	@:optional var fog : Bool;
}