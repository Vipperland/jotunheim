package js.three;

import js.html.*;

// Compressed texture formats
@:native("THREE.CompressedPixelFormat")
extern enum CompressedPixelFormat
{
	RGB_S3TC_DXT1_Format;
	RGBA_S3TC_DXT1_Format;
	RGBA_S3TC_DXT3_Format;
	RGBA_S3TC_DXT5_Format;
}