package js.three;

import js.html.*;

@:native("THREE.LensFlareProperty")
extern interface LensFlareProperty
{
	var texture : Texture;             // Texture
	var size : Float;             // size in pixels (-1 = use texture.width)
	var distance : Float;             // distance (0-1) from light source (0=at light source)
	var x : Float;
	var y : Float;
	var z : Float;            // screen position (-1 =>  1) z = 0 is ontop z = 1 is back
	var scale : Float;             // scale
	var rotation : Float;             // rotation
	var opacity : Float;            // opacity
	var color : Color;                // color
	var blending : Blending;
}