package js.three;

import js.html.*;

@:native("THREE.ArrowHelper")
extern class ArrowHelper extends Object3D
{
	function new(dir:Vector3, ?origin:Vector3, ?length:Float, ?hex:Int, ?headLength:Float, ?headWidth:Float) : Void;

	var line : Line;
	var cone : Mesh;

	function setDirection(dir:Vector3) : Void;
	function setLength(length:Float,  ?headLength:Float, ?headWidth:Float) : Void;
	function setColor(hex:Int) : Void;
}