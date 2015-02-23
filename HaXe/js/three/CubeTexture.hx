package js.three;

import js.html.*;

@:native("THREE.CubeTexture")
extern class CubeTexture extends Texture
{
	function new(
		images: Array<Dynamic>, // HTMLImageElement or HTMLCanvasElement
		?mapping:Mapping,
		?wrapS:Wrapping,
		?wrapT:Wrapping,
		?magFilter:TextureFilter,
		?minFilter:TextureFilter,
		?format:PixelFormat,
		?type:TextureDataType,
		?anisotropy:Float
	) : Void;

	var images : Array<Dynamic>;

	@:overload(function(?texture:CubeTexture):CubeTexture{})
	override function clone() : Texture;
}