package js.three;

import js.html.*;

@:native("THREE.BoxHelper")
extern class BoxHelper extends Line
{
	function new(?object:Object3D) : Void;

	function update(?object:Object3D) : Void;
}