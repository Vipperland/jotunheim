package js.three;

import js.html.*;

@:native("THREE.TorusGeometry")
extern class TorusGeometry extends Geometry
{
	function new(?radius:Float, ?tube:Float, ?radialSegments:Float, ?tubularSegments:Float, ?arc:Float) : Void;

	var parameters : {
		radius: Float,
		tube: Float,
		radialSegments: Float,
		tubularSegments: Float,
		arc: Float
	};
	var radius : Float;
	var tube : Float;
	var radialSegments : Float;
	var tubularSegments : Float;
	var arc : Float;
}