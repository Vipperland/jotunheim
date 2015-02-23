package js.three;

import js.html.*;

@:native("THREE.TorusKnotGeometry")
extern class TorusKnotGeometry extends Geometry
{
	function new(?radius:Float, ?tube:Float, ?radialSegments:Float, ?tubularSegments:Float, ?p:Float, ?q:Float, ?heightScale:Float) : Void;

	var parameters : {
		radius: Float,
		tube: Float,
		radialSegments: Float,
		tubularSegments: Float,
		p: Float,
		q: Float,
		heightScale: Float
	};
	var radius : Float;
	var tube : Float;
	var radialSegments : Float;
	var tubularSegments : Float;
	var p : Float;
	var q : Float;
	var heightScale : Float;
}