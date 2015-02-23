package js.three;

import js.html.*;

// Shadowing Type
@:native("THREE")
extern enum ShadowMapType
{
	BasicShadowMap;
	PCFShadowMap;
	PCFSoftShadowMap;
}