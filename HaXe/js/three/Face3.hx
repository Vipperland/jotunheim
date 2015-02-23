package js.three;

import js.html.*;

/**
 * Triangle face.
 *
 * # Example
 *     var normal = new THREE.Vector3(0, 1, 0);
 *     var color = new THREE.Color(0xffaa00);
 *     var face = new THREE.Face3(0, 1, 2, normal, color, 0);
 *
 * @source https://github.com/mrdoob/three.js/blob/master/src/core/Face3.js
 */
@:native("THREE.Face3")
extern class Face3
{
	/**
	 * @param a Vertex A index.
	 * @param b Vertex B index.
	 * @param c Vertex C index.
	 * @param normal Face normal or array of vertex normals.
	 * @param color Face color or array of vertex colors.
	 * @param materialIndex Material index.
	 */
	@:overload(function(a:Int, b:Int, c:Int, ?normal:Vector3, ?vertexColors:Array<Color>, ?materialIndex:Int):Void{})
	@:overload(function(a:Int, b:Int, c:Int, ?vertexNormals:Array<Vector3>, ?color:Color, ?materialIndex:Int):Void{})
	@:overload(function(a:Int, b:Int, c:Int, ?vertexNormals:Array<Vector3>, ?vertexColors:Array<Color>, ?materialIndex:Int):Void{})
	function new(a:Int, b:Int, c:Int, ?normal:Vector3, ?color:Color, ?materialIndex:Int) : Void;

	/**
	 * Vertex A index.
	 */
	var a : Int;

	/**
	 * Vertex B index.
	 */
	var b : Int;

	/**
	 * Vertex C index.
	 */
	var c : Int;

	/**
	 * Face normal.
	 */
	var normal : Vector3;

	/**
	 * Array of 4 vertex normals.
	 */
	var vertexNormals : Array<Vector3>;

	/**
	 * Face color.
	 */
	var color : Color;

	/**
	 * Array of 4 vertex normals.
	 */
	var vertexColors : Array<Color>;

	/**
	 * Array of 4 vertex tangets.
	 */
	var vertexTangents : Array<Float>;

	/**
	 * Material index (points to {@link Geometry.materials }).
	 */
	var materialIndex : Int;

	function clone() : Face3;
}