package js.three;

import js.html.*;

typedef TextGeometryParameters =
{
	@:optional var size : Float; // size of the text
	@:optional var height : Float; // thickness to extrude text
	@:optional var curveSegments : Float; // number of points on the curves
	@:optional var font : String; // font name
	@:optional var weight : String; // font weight (normal, bold)
	@:optional var style : String; // font style  (normal, italics)
	@:optional var bevelEnabled : Bool;   // turn on bevel
	@:optional var bevelThickness : Float; // how deep into text bevel goes
	@:optional var bevelSize : Float; // how far from text outline is bevel
}