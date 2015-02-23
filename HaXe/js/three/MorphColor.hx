package js.three;

import js.html.*;

@:native("THREE.MorphColor")
extern interface MorphColor
{
	var name : String;
	var colors : Array<Color>;
}