package js.three;

import js.html.*;

// GL STATE CONSTANTS
@:native("THREE")
extern enum CullFace
{
	CullFaceNone;
	CullFaceBack;
	CullFaceFront;
	CullFaceFrontBack;
}