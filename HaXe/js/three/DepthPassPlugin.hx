package js.three;

import js.html.*;

@:native("THREE.DepthPassPlugin")
extern class DepthPassPlugin implements RendererPlugin
{
	function new() : Void;

	var enabled : Bool;
	var renderTarget : RenderTarget;

	@:overload(function(renderer:Renderer):Void{})
	function init(renderer:WebGLRenderer) : Void;
	@:overload(function(scene:Scene,camera:Camera):Void{})
	function render(scene:Scene, camera:Camera, currentWidth:Float, currentHeight:Float) : Void;
	function update(scene:Scene, camera:Camera) : Void;
}