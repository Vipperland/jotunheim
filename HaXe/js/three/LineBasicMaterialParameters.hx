package js.three;

import js.html.*;

typedef LineBasicMaterialParameters =
{
	>MaterialParameters,

	@:optional var color : Int;
	@:optional var linewidth : Float;
	@:optional var linecap : String;
	@:optional var linejoin : String;
	@:optional var vertexColors : Colors;
	@:optional var fog : Bool;
}