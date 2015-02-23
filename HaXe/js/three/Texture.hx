package js.three;

import js.html.*;

@:native("THREE.Texture")
extern class Texture
{
	@:overload(function(
		image: js.html.CanvasElement,
		?mapping:Mapping,
		?wrapS:Wrapping,
		?wrapT:Wrapping,
		?magFilter:TextureFilter,
		?minFilter:TextureFilter,
		?format:PixelFormat,
		?type:TextureDataType,
		?anisotropy:Float
		):Void{})
	@:overload(function(
		image: js.html.ImageElement,
		?mapping:MappingConstructor,
		?wrapS:Wrapping,
		?wrapT:Wrapping,
		?magFilter:TextureFilter,
		?minFilter:TextureFilter,
		?format:PixelFormat,
		?type:TextureDataType,
		?anisotropy:Float
		):Void{})
	@:overload(function(
		image: js.html.CanvasElement,
		?mapping:MappingConstructor,
		?wrapS:Wrapping,
		?wrapT:Wrapping,
		?magFilter:TextureFilter,
		?minFilter:TextureFilter,
		?format:PixelFormat,
		?type:TextureDataType,
		?anisotropy:Float
		):Void{})
	function new(
		image: Dynamic, // HTMLImageElement or HTMLCanvasElement
		?mapping:Mapping,
		?wrapS:Wrapping,
		?wrapT:Wrapping,
		?magFilter:TextureFilter,
		?minFilter:TextureFilter,
		?format:PixelFormat,
		?type:TextureDataType,
		?anisotropy:Float
		) : Void;

	var id : Int;
	var uuid : String;
	var name : String;
	var image : Dynamic; // HTMLImageElement or ImageData ;
	var mipmaps : Array<ImageData>;
	var mapping : Mapping;
	var wrapS : Wrapping;
	var wrapT : Wrapping;
	var magFilter : TextureFilter;
	var minFilter : TextureFilter;
	var anisotropy : Float;
	var format : PixelFormat;
	var type : TextureDataType;
	var offset : Vector2;
	var repeat : Vector2;
	var generateMipmaps : Bool;
	var premultiplyAlpha : Bool;
	var flipY : Bool;
	var unpackAlignment : Float;
	var needsUpdate : Bool;
	var onUpdate : Void->Void;
	static var DEFAULT_IMAGE : Dynamic;
	static var DEFAULT_MAPPING : Dynamic;

	function clone() : Texture;
	function update() : Void;
	function dispose() : Void;

	// EventDispatcher mixins
	function addEventListener(type:String, listener:Dynamic->Void) : Void;
	function hasEventListener(type:String, listener:Dynamic->Void) : Void;
	function removeEventListener(type:String, listener:Dynamic->Void) : Void;
	function dispatchEvent(event: { type: String, target:Dynamic }) : Void;
}