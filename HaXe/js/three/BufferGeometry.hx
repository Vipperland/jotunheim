package js.three;

import js.html.*;

/**
 * This is a superefficent class for geometries because it saves all data in buffers.
 * It reduces memory costs and cpu cycles. But it is not as easy to work with because of all the nessecary buffer calculations.
 * It is mainly interesting when working with static objects.
 *
 * @see <a href="https://github.com/mrdoob/three.js/blob/master/src/core/BufferGeometry.js">src/core/BufferGeometry.js</a>
 */
@:native("THREE.BufferGeometry")
extern class BufferGeometry
{
	/**
	 * This creates a new BufferGeometry. It also sets several properties to an default value.
	 */
	function new() : Void;

	/**
	 * Unique number of this buffergeometry instance
	 */
	var id : Int;
	var uuid : String;
	var name : String;
	var attributes : Array<BufferAttribute>;
	var drawcalls : Array<{ start: Int, count:Float, index:Int }>;
	var offsets : Array<{ start: Int, count:Float, index:Int }>;
	var boundingBox : BoundingBox3D;
	var boundingSphere : BoundingSphere;

	@:overload(function(name:String, array:Dynamic, itemSize:Float):Dynamic{})
	function addAttribute(name:String, attribute:BufferAttribute) : Dynamic;
	function getAttribute(name:String) : Dynamic;
	function addDrawCall(start:Int, count:Float, index:Int) : Void;

	/**
	 * Bakes matrix transform directly into vertex coordinates.
	 */
	function applyMatrix(matrix:Matrix4) : Void;

	function fromGeometry(geometry:Geometry, ?settings:Dynamic) : BufferGeometry;

	/**
	 * Computes bounding box of the geometry, updating Geometry.boundingBox attribute.
	 * Bounding boxes aren't computed by default. They need to be explicitly computed, otherwise they are null.
	 */
	function computeBoundingBox() : Void;

	/**
	 * Computes bounding sphere of the geometry, updating Geometry.boundingSphere attribute.
	 * Bounding spheres aren't' computed by default. They need to be explicitly computed, otherwise they are null.
	 */
	function computeBoundingSphere() : Void;

	/**
	 * @deprecated
	 */
	function computeFaceNormals() : Void;

	/**
	 * Computes vertex normals by averaging face normals.
	 */
	function computeVertexNormals() : Void;

	/**
	 * Computes vertex tangents.
	 * Based on http://www.terathon.com/code/tangent.html
	 * Geometry must have vertex UVs (layer 0 will be used).
	 */
	function computeTangents() : Void;

	function computeOffsets(indexBufferSize:Float) : Void;
	function merge() : Void;
	function normalizeNormals() : Void;
	function reorderBuffers(indexBuffer:Float, indexMap:Array<Float>, vertexCount:Int) : Void;
	function clone() : BufferGeometry;

	/**
	 * Disposes the object from memory.
	 * You need to call this when you want the bufferGeometry removed while the application is running.
	 */
	function dispose() : Void;


	// EventDispatcher mixins
	function addEventListener(type:String, listener:Dynamic->Void) : Void;
	function hasEventListener(type:String, listener:Dynamic->Void) : Void;
	function removeEventListener(type:String, listener:Dynamic->Void) : Void;
	function dispatchEvent(event: { type: String, target:Dynamic }) : Void;
}