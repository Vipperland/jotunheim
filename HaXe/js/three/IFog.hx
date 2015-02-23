package js.three;

import js.html.*;

@:native("THREE.IFog")
extern interface IFog
{
	var name : String;
	var color : Color;
	function clone() : IFog;
}