package jotun.math;

/**
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */

interface ITransform3D {
	public var rotation : IPoint3D;
	public var location : IPoint3D;
	public var scale : IPoint3D;
	public var transformStyle : String;
	public var transformOrigin : String;
	public var backFace : String;
	public var perspective : String;
}