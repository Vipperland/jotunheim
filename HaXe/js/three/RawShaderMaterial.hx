package js.three;

import js.html.*;

@:native("THREE.RawShaderMaterial")
extern class RawShaderMaterial extends ShaderMaterial
{
	function new(?parameters:ShaderMaterialParameters) : Void;
}