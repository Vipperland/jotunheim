package js.three;

import js.html.*;

@:native("THREE.GeometryUtils")
extern class GeometryUtils
{
	/**
	 * @deprecated
	 */
	//static function merge(geometry1:Geometry, object2:Mesh, ?materialIndexOffset:Float) : Void;

	/**
	 * @deprecated
	 */
	static function merge(geometry1:Geometry, object2:Geometry, ?materialIndexOffset:Float) : Void;

	/**
	 * @deprecated
	 */
	static function center(geometry:Geometry) : Vector3;
}