package js.three;

import js.html.*;

// custom blending destination factors
@:native("THREE.BlendingDstFactor")
extern enum BlendingDstFactor
{
	ZeroFactor;
	OneFactor;
	SrcColorFactor;
	OneMinusSrcColorFactor;
	SrcAlphaFactor;
	OneMinusSrcAlphaFactor;
	DstAlphaFactor;
	OneMinusDstAlphaFactor;
}