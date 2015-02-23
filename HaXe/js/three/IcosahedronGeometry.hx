package js.three;

import js.html.*;

@:native("THREE.IcosahedronGeometry")
extern class IcosahedronGeometry extends PolyhedronGeometry
{
	function new(radius:Float, detail:Int) : Void;

	var parameters : {
		radius: Float,
		detail: Int
	};
	var radius : Float;
	var detail : Int;
}