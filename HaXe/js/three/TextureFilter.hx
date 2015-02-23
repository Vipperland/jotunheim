package js.three;

import js.html.*;

// Filters
@:native("THREE.TextureFilter")
extern enum TextureFilter
{
	NearestFilter;
	NearestMipMapNearestFilter;
	NearestMipMapLinearFilter;
	LinearFilter;
	LinearMipMapNearestFilter;
	LinearMipMapLinearFilter;
}