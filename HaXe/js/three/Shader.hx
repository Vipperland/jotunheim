package js.three;

import js.html.*;

@:native("THREE.Shader")
extern interface Shader
{
	var uniforms : Dynamic;
	var vertexShader : String;
	var fragmentShader : String;
}