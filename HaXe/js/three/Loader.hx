package js.three;

import js.html.*;

/**
 * Base class for implementing loaders.
 *
 * Events:
 *     load
 *         Dispatched when the image has completed loading
 *         content — loaded image
 *
 *     error
 *
 *          Dispatched when the image can't be loaded
 *          message — error message
 */
@:native("THREE.Loader")
extern class Loader
{
	function new(?showStatus:Bool) : Void;

	/**
	 * If true, show loading status in the statusDomElement.
	 */
	var showStatus : Bool;

	/**
	 * This is the recipient of status messages.
	 */
	var statusDomElement : HtmlElement;

	/**
	 * Will be called when load starts.
	 * The default is a function with empty body.
	 */
	var onLoadStart : Void->Void;

	/**
	 * Will be called while load progresses.
	 * The default is a function with empty body.
	 */
	var onLoadProgress : Void->Void;

	/**
	 * Will be called when load completes.
	 * The default is a function with empty body.
	 */
	var onLoadComplete : Void->Void;

	/**
	 * default — null.
	 * If set, assigns the crossOrigin attribute of the image to the value of crossOrigin, prior to starting the load.
	 */
	var crossOrigin : String;

	function addStatusElement() : HtmlElement;
	function updateProgress(progress:Progress) : Void;
	function extractUrlBase(url:String) : String;
	function initMaterials(materials:Array<Material>, texturePath:String) : Array<Material>;
	function needsTangents(materials:Array<Material>) : Bool;
	function createMaterial(m:Material, texturePath:String) : Bool;

	static var Handlers : LoaderHandler;
}