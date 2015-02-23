package js.three;

import js.html.*;

@:native("THREE.CylinderGeometry")
extern class CylinderGeometry extends Geometry
{
	/**
	 * @param radiusTop — Radius of the cylinder at the top.
	 * @param radiusBottom — Radius of the cylinder at the bottom.
	 * @param height — Height of the cylinder.
	 * @param radiusSegments — Number of segmented faces around the circumference of the cylinder.
	 * @param heightSegments — Number of rows of faces along the height of the cylinder.
	 * @param openEnded - A Boolean indicating whether or not to cap the ends of the cylinder.
	 */
	function new(?radiusTop:Float, ?radiusBottom:Float, ?height:Float, ?radiusSegments:Float, ?heightSegments:Float, ?openEnded:Bool) : Void;

	var parameters : {
		radiusTop: Float,
		radiusBottom: Float,
		height: Float,
		radialSegments: Float,
		heightSegments: Float,
		openEnded: Bool
	};
	var radiusTop : Float;
	var radiusBottom : Float;
	var height : Float;
	var radialSegments : Float;
	var heightSegments : Float;
	var openEnded : Bool;
}