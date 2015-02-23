package js.three;

import js.html.*;

@:native("THREE.PathActions")
extern enum PathActions
{
	MOVE_TO;
	LINE_TO;
	QUADRATIC_CURVE_TO; // Bezier quadratic curve
	BEZIER_CURVE_TO;     // Bezier cubic curve
	CSPLINE_THRU;        // Catmull-rom spline
	ARC;                // Circle
	ELLIPSE;
}