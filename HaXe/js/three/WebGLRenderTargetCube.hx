package js.three;

import js.html.*;

@:native("THREE.WebGLRenderTargetCube")
extern class WebGLRenderTargetCube extends WebGLRenderTarget
{
	function new(width:Float, height:Float, ?options:WebGLRenderTargetOptions) : Void;

	var activeCubeFace : Float; // PX 0, NX 1, PY 2, NY 3, PZ 4, NZ 5
}