package js.three;

import js.html.*;

@:native("THREE.RendererPlugin")
extern interface RendererPlugin
{
	function init(renderer:WebGLRenderer) : Void;
	function render(scene:Scene, camera:Camera, currentWidth:Float, currentHeight:Float) : Void;
}