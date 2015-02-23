package js.three;

import js.html.*;

// Renderers / WebGL /////////////////////////////////////////////////////////////////////
@:native("THREE.WebGLProgram")
extern class WebGLProgram
{
	function new(renderer:WebGLRenderer, code:String, material:ShaderMaterial, parameters:WebGLRendererParameters) : Void;
}