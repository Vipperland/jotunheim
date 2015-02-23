package js.three;

import js.html.*;

@:native("THREE.WireframeHelper")
extern class WireframeHelper extends Line
{
	function new(object:Object3D, ?hex:Int) : Void;
}