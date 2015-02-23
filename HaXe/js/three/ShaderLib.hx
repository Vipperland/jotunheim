package js.three;

import js.html.*;

@:native("THREE.ShaderLib")
extern class ShaderLib implements Dynamic<Shader>
{
	static var basic : Shader;
	static var lambert : Shader;
	static var phong : Shader;
	static var particle_basic : Shader;
	static var dashed : Shader;
	static var depth : Shader;
	static var normal : Shader;
	static var normalmap : Shader;
	static var cube : Shader;
	static var depthRGBA : Shader;
}