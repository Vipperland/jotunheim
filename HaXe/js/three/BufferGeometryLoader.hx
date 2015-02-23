package js.three;

import js.html.*;

@:native("THREE.BufferGeometryLoader")
extern class BufferGeometryLoader
{
	function new(?manager:LoadingManager) : Void;

	function load(url:String, onLoad:BufferGeometry->Void, ?onProgress:Dynamic->Void, ?onError:Dynamic->Void) : Void;
	function setCrossOrigin(crossOrigin:String) : Void;
	function parse(json:Dynamic) : BufferGeometry;
}