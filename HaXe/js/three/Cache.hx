package js.three;

import js.html.*;

@:native("THREE.Cache")
extern class Cache
{
	function new() : Void;

	var files : Array<Dynamic>;

	function add(key:String, file:Dynamic) : Void;
	function get(key:String) : Dynamic;
	function remove(key:String) : Void;
	function clear() : Void;
}