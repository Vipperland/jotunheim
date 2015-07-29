package sirius.dom;
import sirius.math.Point3D;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IDisplay3D extends IDisplay {
  
	public var rotation : Point3D;
	
	public var location : Point3D;
	
	public var scale : Point3D;
	
	public var perspective : String;
	
	public var transformOrigin : String;
	
	public var transformStyle : String;
	
	public function preserve3d() : IDisplay3D;
	
	public function setPerspective(value:String, ?origin:String) : IDisplay3D;

	public function rotateAll (x:Float, y:Float, z:Float, ?add:Bool) : IDisplay3D;

	public function rotationX (?value:Float, ?add:Bool) : Float;

	public function rotationY (?value:Float, ?add:Bool) : Float;

	public function rotationZ (?value:Float, ?add:Bool) : Float;

	public function moveTo (x:Float, y:Float, z:Float, ?add:Bool) : IDisplay3D;

	public function locationX (?value:Float, ?add:Bool) : Float;

	public function locationY (?value:Float, ?add:Bool) : Float;

	public function locationZ (?value:Float, ?add:Bool) : Float;

	public function scaleAll (x:Float, y:Float, z:Float, ?add:Bool) : IDisplay3D;

	public function scaleX (?value:Float, ?add:Bool) : Float;

	public function scaleY (?value:Float, ?add:Bool) : Float;

	public function scaleZ (?value:Float, ?add:Bool) : Float;
	
	public function transform(x:Float, y:Float, z:Float, x1:Float, y1:Float, z1:Float, w:Float, h:Float, d:Float):IDisplay;

	public function update () : IDisplay;
	
	public function doubleSided(value:Bool):IDisplay3D;
	
	public function flipHorizontal() : IDisplay3D;
	
	public function flipVertical() : IDisplay3D;
	
}