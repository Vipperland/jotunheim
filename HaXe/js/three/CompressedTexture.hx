package js.three;

import js.html.*;

// Textures /////////////////////////////////////////////////////////////////////
@:native("THREE.CompressedTexture")
extern class CompressedTexture extends Texture
{
	function new(
		mipmaps: Array<ImageData>,
		width: Int,
		height: Int,
		?format:PixelFormat,
		?type:TextureDataType,
		?mapping:Mapping,
		?wrapS:Wrapping,
		?wrapT:Wrapping,
		?magFilter:TextureFilter,
		?minFilter:TextureFilter,
		?anisotropy:Float
	) : Void;

	//var image : { width: Int, height:Int };
	//var mipmaps : Array<ImageData>;
	//var generateMipmaps : Bool;

	@:overload(function():CompressedTexture{})
	override function clone() : Texture;
}