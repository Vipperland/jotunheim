package js.three;

import js.html.*;

// Mapping modes
@:native("THREE")
extern class Mappings
{
	static function UVMapping() : Mapping;
    static function CubeReflectionMapping() : Mapping;
    static function CubeRefractionMapping() : Mapping;
    static function SphericalReflectionMapping() : Mapping;
    static function SphericalRefractionMapping() : Mapping;
}