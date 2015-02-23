package js.three;

import js.html.*;

// custom blending equations
// (numbers start from 100 not to clash with other
//  mappings to OpenGL constants defined in Texture.js)
@:native("THREE.BlendingEquation")
extern enum BlendingEquation
{
	AddEquation;
	SubtractEquation;
	ReverseSubtractEquation;
}