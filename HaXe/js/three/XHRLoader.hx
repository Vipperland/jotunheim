package js.three;

import js.html.*;

@:native("THREE.XHRLoader")
extern class XHRLoader
{
	function new(?manager:LoadingManager) : Void;

	var responseType : String;
	var crossOrigin : String;

	function load(url:String, ?onLoad:String->Void, ?onProgress:Dynamic->Void, ?onError:Dynamic->Void) : Void;
	function setResponseType(responseType:String) : Void;
	function setCrossOrigin(crossOrigin:String) : Void;
}