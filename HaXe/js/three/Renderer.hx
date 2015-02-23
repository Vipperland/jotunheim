package js.three;

import js.html.*;

@:native("THREE.Renderer")
extern interface Renderer
{
	function render(scene:Scene, camera:Camera) : Void;
	function setSize(width:Float, height:Float, ?updateStyle:Bool) : Void;
	var domElement : js.html.CanvasElement;
}