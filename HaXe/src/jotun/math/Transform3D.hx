package jotun.math;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Transform3D implements ITransform3D {
	
	public var rotation:IPoint3D;
	
	public var location:IPoint3D;
	
	public var scale:IPoint3D;
	
	public var transformStyle:String;
	
	public var transformOrigin:String;
	
	public var backFace:String;
	
	public var perspective:String;
	
	public function new() {
		rotation = new Point3D(0, 0, 0);
		location = new Point3D(0, 0, 0);
		scale = new Point3D(1, 1, 1);
		transformStyle = "preserve-3d";
		transformOrigin = "50% 50%";
		backFace = "hidden";
		perspective = "";
	}
	
}