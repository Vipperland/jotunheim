package js.three;

import js.html.*;

@:native("THREE.TextGeometry")
extern class TextGeometry extends ExtrudeGeometry
{
	function new(text:String, ?TextGeometryParameters:TextGeometryParameters) : Void;
}