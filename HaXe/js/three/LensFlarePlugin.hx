package js.three;

import js.html.*;

@:native("THREE.LensFlarePlugin")
extern class LensFlarePlugin implements RendererPlugin
{
	function new() : Void;

	@:overload(function(renderer:Renderer):Void{})
	function init(renderer:WebGLRenderer) : Void;
	@:overload(function(scene:Scene,camera:Camera,viewportWidth:Float,viewportHeight:Float):Void{})
	function render(scene:Scene, camera:Camera, currentWidth:Float, currentHeight:Float) : Void;
}