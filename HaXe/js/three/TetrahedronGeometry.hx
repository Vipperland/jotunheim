package js.three;

import js.html.*;

@:native("THREE.TetrahedronGeometry")
extern class TetrahedronGeometry extends PolyhedronGeometry
{
	function new(?radius:Float, ?detail:Float) : Void;
}