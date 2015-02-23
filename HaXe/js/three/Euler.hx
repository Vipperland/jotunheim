package js.three;

import js.html.*;

@:native("THREE.Euler")
extern class Euler
{
	function new(?x:Float, ?y:Float, ?z:Float, ?order:String) : Void;

	var x : Float;
	var y : Float;
	var z : Float;
	var order : String;

	function set(x:Float, y:Float, z:Float, ?order:String) : Euler;
	function copy(euler:Euler) : Euler;
	function setFromRotationMatrix(m:Matrix4, ?order:String) : Euler;
	function setFromQuaternion(q:Quaternion, ?order:String, ?update:Bool) : Euler;
	function reorder(newOrder:String) : Euler;
	function equals(euler:Euler) : Bool;
	function fromArray(xyzo:Array<Dynamic>) : Euler;
	function toArray() : Array<Dynamic>;
	var onChange : Void->Void;

	function clone() : Euler;
}