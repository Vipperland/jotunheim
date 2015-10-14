package sirius.dom;
import sirius.math.ITransform3D;
import sirius.math.Point3D;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IDisplay3D extends IDisplay {
  
	public var transform : ITransform3D;
	
	public function preserve3d() : IDisplay3D;
	
	public function setPerspective(value:String, ?origin:String) : IDisplay3D;

	public function rotateAll (x:Float, y:Float, ?z:Float, ?add:Bool) : IDisplay3D;

	public function rotationX (?value:Float, ?add:Bool) : Float;

	public function rotationY (?value:Float, ?add:Bool) : Float;

	public function rotationZ (?value:Float, ?add:Bool) : Float;

	public function moveTo (x:Float, y:Float, ?z:Float, ?add:Bool) : IDisplay3D;

	public function locationX (?value:Float, ?add:Bool) : Float;

	public function locationY (?value:Float, ?add:Bool) : Float;

	public function locationZ (?value:Float, ?add:Bool) : Float;

	public function scaleAll (x:Float, y:Float, ?z:Float, ?add:Bool) : IDisplay3D;

	public function scaleX (?value:Float, ?add:Bool) : Float;

	public function scaleY (?value:Float, ?add:Bool) : Float;

	public function scaleZ (?value:Float, ?add:Bool) : Float;
	
	public function transform2D(x:Float, y:Float, x1:Float, y1:Float, w:Float, h:Float):IDisplay;
	
	public function transform3D(x:Float, y:Float, z:Float, x1:Float, y1:Float, z1:Float, w:Float, h:Float, d:Float):IDisplay;

	public function update () : IDisplay;
	
	public function doubleSided(value:Bool):IDisplay3D;
	
	public function flipHorizontal() : IDisplay3D;
	
	public function flipVertical() : IDisplay3D;
	
}