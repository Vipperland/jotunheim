package js.three;

import js.html.*;

@:native("THREE.MaterialLoader")
extern class MaterialLoader
{
	function new(?manager:LoadingManager) : Void;

	function load(url:String, onLoad:Material->Void) : Void;
	function setCrossOrigin(crossOrigin:String) : Void;
	function parse(json:Dynamic) : Material;
}