package js.three;

import js.html.*;

@:native("THREE.WebGLRenderTargetOptions")
extern interface WebGLRenderTargetOptions
{
	@:optional var wrapS : Wrapping;
	@:optional var wrapT : Wrapping;
	@:optional var magFilter : TextureFilter;
	@:optional var minFilter : TextureFilter;
	@:optional var anisotropy : Float; // 1;
	@:optional var format : Float; // RGBAFormat;
	@:optional var type : TextureDataType; // UnsignedByteType;
	@:optional var depthBuffer : Bool; // true;
	@:optional var stencilBuffer : Bool; // true;
}