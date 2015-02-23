package js.three;

import js.html.*;

/**
 * A class for displaying particles in the form of variable size points. For example, if using the WebGLRenderer, the particles are displayed using GL_POINTS.
 *
 * @see <a href="https://github.com/mrdoob/three.js/blob/master/src/objects/ParticleSystem.js">src/objects/ParticleSystem.js</a>
 */
@:native("THREE.PointCloud")
extern class PointCloud extends Object3D
{

	/**
	 * @param geometry An instance of Geometry.
	 * @param material An instance of Material (optional).
	 */
	@:overload(function(geometry:Geometry, ?material:ShaderMaterial):Void{})
	@:overload(function(geometry:BufferGeometry, ?material:PointCloudMaterial):Void{})
	@:overload(function(geometry:BufferGeometry, ?material:ShaderMaterial):Void{})
	function new(geometry:Geometry, ?material:PointCloudMaterial) : Void;

	/**
	 * An instance of Geometry, where each vertex designates the position of a particle in the system.
	 */
	var geometry : Geometry;

	/**
	 * An instance of Material, defining the object's appearance. Default is a ParticleBasicMaterial with randomised colour.
	 */
	var material : Material;
	var sortParticles : Bool;

	override function raycast(raycaster:Raycaster, intersects:Dynamic) : Void;
	@:overload(function(?object:PointCloud):PointCloud{})
	override function clone(?object:Object3D, ?recursive:Bool) : Object3D;
}