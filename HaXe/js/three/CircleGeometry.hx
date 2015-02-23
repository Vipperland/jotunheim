package js.three;

import js.html.*;

@:native("THREE.CircleGeometry")
extern class CircleGeometry extends Geometry
{
	function new(?radius:Float, ?segments:Float, ?thetaStart:Float, ?thetaLength:Float) : Void;

	var parameters : {
		radius: Float,
		segments: Float,
		thetaStart: Float,
		thetaLength: Float
	};
	var radius : Float;
	var segments : Float;
	var thetaStart : Float;
	var thetaLength : Float;
}