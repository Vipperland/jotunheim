package js.three;

import js.html.*;

// Core ///////////////////////////////////////////////////////////////////////////////////////////////
@:native("THREE.BufferAttribute")
extern class BufferAttribute
{
	function new(array:Dynamic, itemSize:Float) : Void; // array parameter should be TypedArray.

	var array : Array<Float>;
	var itemSize : Float;
	var length : Float;

	function set(value:Float) : BufferAttribute;
	function setX(index:Int, x:Float) : BufferAttribute;
	function setY(index:Int, y:Float) : BufferAttribute;
	function setZ(index:Int, z:Float) : BufferAttribute;
	function setXY(index:Int, x:Float, y:Float) : BufferAttribute;
	function setXYZ(index:Int, x:Float, y:Float, z:Float) : BufferAttribute;
	function setXYZW(index:Int, x:Float, y:Float, z:Float, w:Float) : BufferAttribute;
}