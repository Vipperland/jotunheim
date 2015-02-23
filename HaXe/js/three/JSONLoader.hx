package js.three;

import js.html.*;

/**
 * A loader for loading objects in JSON format.
 */
@:native("THREE.JSONLoader")
extern class JSONLoader extends Loader
{
	function new(?showStatus:Bool) : Void;

	var withCredentials : Bool;

	/**
	 * @param url
	 * @param callback. This function will be called with the loaded model as an instance of geometry when the load is completed.
	 * @param texturePath If not specified, textures will be assumed to be in the same folder as the Javascript model file.
	 */
	function load(url:String, callback:JSonLoaderResultGeometry->Array<Material>->Void, ?texturePath:String) : Void;

	function loadAjaxJSON(context:JSONLoader, url:String, callback:Geometry->Array<Material>->Void, ?texturePath:String, ?callbackProgress:Progress->Void) : Void;

	function parse(json:Dynamic, ?texturePath:String) : { geometry: Geometry, ?materials:Array<Material> };
}