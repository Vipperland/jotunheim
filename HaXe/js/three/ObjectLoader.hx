package js.three;

import js.html.*;

@:native("THREE.ObjectLoader")
extern class ObjectLoader
{
	function new(?manager:LoadingManager) : Void;

	function load(url:String, onLoad:Object3D->Void) : Void;
	function setCrossOrigin(crossOrigin:String) : Void;
	function parse<T:Object3D>(json:Dynamic) : T;
	function parseGeometries(json:Dynamic) : Array<Dynamic>; // Array of BufferGeometry or Geometry or Geometry2.
	function parseMaterials(json:Dynamic) : Array<Material>; // Array of Classes that inherits from Matrial.
	function parseObject<T:Object3D>(data:Dynamic, geometries:Array<Dynamic>, materials:Array<Material>) : T;
}