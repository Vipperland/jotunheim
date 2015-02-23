package js.three;

import js.html.*;

@:native("THREE.TubeGeometry")
extern class TubeGeometry extends Geometry
{
	function new(path:Path, ?segments:Float, ?radius:Float, ?radiusSegments:Float, ?closed:Bool) : Void;

	var parameters : {
		path: Path,
		segments: Float,
		radius: Float,
		radialSegments: Float,
		closed: Bool
	};
	var path : Path;
	var segments : Float;
	var radius : Float;
	var radialSegments : Float;
	var closed : Bool;
	var tangents : Array<Vector3>;
	var normals : Array<Vector3>;
	var binormals : Array<Vector3>;

	function FrenetFrames(path:Path, segments:Float, closed:Bool) : Void;
}