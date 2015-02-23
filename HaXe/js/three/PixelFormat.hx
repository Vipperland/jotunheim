package js.three;

import js.html.*;

// Pixel formats
@:native("THREE.PixelFormat")
extern enum PixelFormat
{
	AlphaFormat;
	RGBFormat;
	RGBAFormat;
	LuminanceFormat;
	LuminanceAlphaFormat;
}