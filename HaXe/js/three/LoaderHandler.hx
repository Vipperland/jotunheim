package js.three;

import js.html.*;

@:native("THREE.LoaderHandler")
extern interface LoaderHandler
{
	var handlers : Array<Dynamic>;
	function add(regex:String, loader:Loader) : Void;
	function get(file:String) : Loader;
}