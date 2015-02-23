package js.three;

import js.html.*;

@:native("THREE.BoundingBox")
extern interface BoundingBox
{
	var minX : Float;
	var minY : Float;
	var maxX : Float;
	var maxY : Float;
	var centroid : Vector;
}