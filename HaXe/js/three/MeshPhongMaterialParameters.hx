package js.three;

import js.html.*;

typedef MeshPhongMaterialParameters =
{
	>MaterialParameters,

	@:optional var color : Int; // diffuse
	@:optional var ambient : Float;
	@:optional var emissive : Float;
	@:optional var specular : Float;
	@:optional var shininess : Float;
	@:optional var metal : Bool;
	@:optional var wrapAround : Bool;
	@:optional var wrapRGB : Vector3;
	@:optional var map : Texture;
	@:optional var lightMap : Texture;
	@:optional var bumpMap : Texture;
	@:optional var bumpScale : Float;
	@:optional var normalMap : Texture;
	@:optional var normalScale : Vector2;
	@:optional var specularMap : Texture;
	@:optional var alphaMap : Texture;
	@:optional var envMap : Texture;
	@:optional var combine : Combine;
	@:optional var reflectivity : Float;
	@:optional var refractionRatio : Float;
	@:optional var fog : Bool;
	@:optional var shading : Shading;
	@:optional var wireframe : Bool;
	@:optional var wireframeLinewidth : Float;
	@:optional var wireframeLinecap : String;
	@:optional var wireframeLinejoin : String;
	@:optional var vertexColors : Colors;
	@:optional var skinning : Bool;
	@:optional var morphTargets : Bool;
	@:optional var morphNormals : Bool;
}