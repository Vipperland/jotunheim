package js.three;

import js.html.*;

typedef SpriteMaterialParameters =
{
	>MaterialParameters,

	@:optional var color : Int;
	@:optional var map : Texture;
	@:optional var rotation : Float;
	@:optional var fog : Bool;
}