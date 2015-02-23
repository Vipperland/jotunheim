package js.three;

import js.html.*;

@:native("THREE.RingGeometry")
extern class RingGeometry extends Geometry
{
	function new(?innerRadius:Float, ?outerRadius:Float, ?thetaSegments:Float, ?phiSegments:Float, ?thetaStart:Float, ?thetaLength:Float) : Void;
}