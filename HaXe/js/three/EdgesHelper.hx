package js.three;

import js.html.*;

@:native("THREE.EdgesHelper")
extern class EdgesHelper extends Line
{
	function new(object:Object3D, ?hex:Int) : Void;
}