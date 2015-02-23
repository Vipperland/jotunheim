package js.three;

import js.html.*;

/**
 * Base class for scene graph objects
 */
@:native("THREE.Object3D")
extern class Object3D
{
	function new() : Void;

	/**
	 * Unique number of this object instance.
	 */
	var id : Int;

	/**
	 *
	 */
	var uuid : String;

	/**
	 * Optional name of the object (doesn't need to be unique).
	 */
	var name : String;

	/**
	 * Object's parent in the scene graph.
	 */
	var parent : Object3D;

	/**
	 * Array with object's children.
	 */
	var children : Array<Object3D>;

	/**
	 * Up direction.
	 */
	var up : Vector3;

	/**
	 * Object's local position.
	 */
	var position : Vector3;

	/**
	 * Object's local rotation (Euler angles), in radians.
	 */
	var rotation : Euler;

	/**
	 * Global rotation.
	 */
	var quaternion : Quaternion;

	/**
	 * Object's local scale.
	 */
	var scale : Vector3;

	/**
	 * Override depth-sorting order if non null.
	 */
	var renderDepth : Float;

	/**
	 * When this is set, then the rotationMatrix gets calculated every frame.
	 */
	var rotationAutoUpdate : Bool;

	/**
	 * Local transform.
	 */
	var matrix : Matrix4;

	/**
	 * The global transform of the object. If the Object3d has no parent, then it's identical to the local transform.
	 */
	var matrixWorld : Matrix4;

	/**
	 * When this is set, it calculates the matrix of position, (rotation or quaternion) and scale every frame and also recalculates the matrixWorld property.
	 */
	var matrixAutoUpdate : Bool;

	/**
	 * When this is set, it calculates the matrixWorld in that frame and resets this property to false.
	 */
	var matrixWorldNeedsUpdate : Bool;

	/**
	 * Object gets rendered if true.
	 */
	var visible : Bool;

	/**
	 * Gets rendered into shadow map.
	 */
	var castShadow : Bool;

	/**
	 * Material gets baked in shadow receiving.
	 */
	var receiveShadow : Bool;

	/**
	 * When this is set, it checks every frame if the object is in the frustum of the camera. Otherwise the object gets drawn every frame even if it isn't visible.
	 */
	var frustumCulled : Bool;

	/**
	 * An object that can be used to store custom data about the Object3d. It should not hold references to functions as these will not be cloned.
	 */
	var userData : Dynamic;

	/**
	 *
	 */
	static var DefaultUp : Vector3;


	/**
	 * Order of axis for Euler angles.
	 * @deprected
	 */
	var eulerOrder : String;


	/**
	 * This updates the position, rotation and scale with the matrix.
	 */
	function applyMatrix(matrix:Matrix4) : Void;

	/**
	 *
	 */
	function setRotationFromAxisAngle(axis:Vector3, angle:Float) : Void;

	/**
	 *
	 */
	function setRotationFromEuler(euler:Euler) : Void;

	/**
	 *
	 */
	function setRotationFromMatrix(m:Matrix4) : Void;

	/**
	 *
	 */
	function setRotationFromQuaternion(q:Quaternion) : Void;

	/**
	 * Rotate an object along an axis in object space. The axis is assumed to be normalized.
	 * @param axis  A normalized vector in object space.
	 * @param angle  The angle in radians.
	 */
	function rotateOnAxis(axis:Vector3, angle:Float) : Object3D;

	/**
	 *
	 * @param angle
	 */
	function rotateX(angle:Float) : Object3D;

	/**
	 *
	 * @param angle
	 */
	function rotateY(angle:Float) : Object3D;

	/**
	 *
	 * @param angle
	 */
	function rotateZ(angle:Float) : Object3D;

	/**
	 * @param axis  A normalized vector in object space.
	 * @param distance  The distance to translate.
	 */
	function translateOnAxis(axis:Vector3, distance:Float) : Object3D;

	/**
	 *
	 * @param distance
	 * @param axis
	 */
	function translate(distance:Float, axis:Vector3) : Object3D;

	/**
	 * Translates object along x axis by distance.
	 * @param distance Distance.
	 */
	function translateX(distance:Float) : Object3D;

	/**
	 * Translates object along y axis by distance.
	 * @param distance Distance.
	 */
	function translateY(distance:Float) : Object3D;

	/**
	 * Translates object along z axis by distance.
	 * @param distance Distance.
	 */
	function translateZ(distance:Float) : Object3D;

	/**
	 * Updates the vector from local space to world space.
	 * @param vector A local vector.
	 */
	function localToWorld(vector:Vector3) : Vector3;

	/**
	 * Updates the vector from world space to local space.
	 * @param vector A world vector.
	 */
	function worldToLocal(vector:Vector3) : Vector3;

	/**
	 * Rotates object to face point in space.
	 * @param vector A world vector to look at.
	 */
	function lookAt(vector:Vector3) : Void;

	/**
	 * Adds object as child of this object.
	 */
	function add(object:Object3D) : Void;

	/**
	 * Removes object as child of this object.
	 */
	function remove(object:Object3D) : Void;

	/**
	 *
	 */
	function raycast(raycaster:Raycaster, intersects:Dynamic) : Void;

	/**
	 * Translates object along arbitrary axis by distance.
	 * @param distance Distance.
	 * @param axis Translation direction.
	 */
	function traverse(callback:Object3D->Dynamic) : Void;

	/**
	 * Searches through the object's children and returns the first with a matching id, optionally recursive.
	 * @param id  Unique number of the object instance
	 * @param recursive  Boolean whether to search through the children's children. Default is false.
	 */
	function getObjectById(id:String, recursive:Bool) : Object3D;


	/**
	 * Searches through the object's children and returns the first with a matching name, optionally recursive.
	 * @param name  String to match to the children's Object3d.name property.
	 * @param recursive  Boolean whether to search through the children's children. Default is false.
	 */
	function getObjectByName(name:String, ?recursive:Bool) : Object3D;


	function getChildByName(name:String, ?recursive:Bool) : Object3D;

	/**
	 * Updates local transform.
	 */
	function updateMatrix() : Void;

	/**
	 * Updates global transform of the object and its children.
	 */
	function updateMatrixWorld(force:Bool) : Void;

	/**
	 *
	 * @param object
	 * @param recursive
	 */
	function clone(?object:Object3D, ?recursive:Bool) : Object3D;

	// EventDispatcher mixins
	function addEventListener(type:String, listener:Dynamic->Void) : Void;
	function hasEventListener(type:String, listener:Dynamic->Void) : Void;
	function removeEventListener(type:String, listener:Dynamic->Void) : Void;
	function dispatchEvent(event: { type: String, target:Dynamic }) : Void;
}