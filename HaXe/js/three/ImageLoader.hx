package js.three;

import js.html.*;

/**
 * A loader for loading an image.
 * Unlike other loaders, this one emits events instead of using predefined callbacks. So if you're interested in getting notified when things happen, you need to add listeners to the object.
 */
@:native("THREE.ImageLoader")
extern class ImageLoader
{
	function new(?manager:LoadingManager) : Void;

	var crossOrigin : String;

	/**
	 * Begin loading from url
	 * @param url
	 */
	function load(url:String, ?onLoad:js.html.ImageElement->Void, ?onProgress:Dynamic->Void, ?onError:Dynamic->Void) : js.html.ImageElement;

	function setCrossOrigin(crossOrigin:String) : Void;
}