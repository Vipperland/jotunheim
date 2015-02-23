package js.three;

import js.html.*;

// blending modes
@:native("THREE.Blending")
extern enum Blending
{
	NoBlending;
	NormalBlending;
	AdditiveBlending;
	SubtractiveBlending;
	MultiplyBlending;
	CustomBlending;
}