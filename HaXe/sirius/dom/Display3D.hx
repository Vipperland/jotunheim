package sirius.dom;
import haxe.Log;
import js.Browser;
import sirius.css.XCSS;
import sirius.dom.IDisplay;
import sirius.math.Point3D;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Display3D")
class Display3D extends Div implements IDisplay3D {
	
	public var rotation:Point3D;
	
	public var location:Point3D;
	
	public var scale:Point3D;
	
	public var info:Dynamic;
	
	public var perspective:String;
	
	public var transformOrigin:String;
	
	public var transformStyle:String;
	
	public var backFace:String;
	
	public var xcss:XCSS;
	
	public function new(?q:Dynamic, ?d:String) {
		super(q, d);
		rotation = new Point3D(0, 0, 0);
		location = new Point3D(0, 0, 0);
		scale = new Point3D(1, 1, 1);
		xcss = new XCSS();
		this.backFace = "visible";
		preserve3d().update();
	}
	
	public function preserve3d():IDisplay3D {
		this.transformStyle = "preserve-3d";
		return this;
	}
	
	public function setPerspective(value:String, ?origin:String):IDisplay3D {
		if (value != null) this.perspective = value;
		if (origin != null) this.transformOrigin = origin;
		return this;
	}
	
	public function rotateAll(x:Float, y:Float, z:Float, ?add:Bool):IDisplay3D {
		rotationX(x, add);
		rotationY(y, add);
		rotationZ(z, add);
		return this;
	}
	
	public function rotationX(?value:Float, ?add:Bool):Float {
		if (value != null) {
			add ? rotation.x += value : rotation.x = value;
			if (rotation.x < -180) rotation.x += 360;
			else if (rotation.x > 180) rotation.x -= 360;
		}
		return rotation.x;
	}
	
	public function rotationY(?value:Float, ?add:Bool):Float {
		if (value != null) {
			add ? rotation.y += value : rotation.y = value;
			if (rotation.y < -180) rotation.y += 360;
			else if (rotation.y > 180) rotation.y -= 360;
		}
		return rotation.y;
	}
	
	public function rotationZ(?value:Float, ?add:Bool):Float {
		if (value != null) {
			add ? rotation.z += value : rotation.z = value;
			if (rotation.z < -180) rotation.z += 360;
			else if (rotation.z > 180) rotation.z -= 360;
		}
		return rotation.z;
	}
	
	public function moveTo(x:Float, y:Float, z:Float, ?add:Bool):IDisplay3D {
		locationX(x,add);
		locationY(y,add);
		locationZ(z,add);
		return this;
	}
	
	public function locationX(?value:Float, ?add:Bool):Float {
		if (value != null) add ? location.x += value : location.x = value;
		return location.x;
	}
	
	public function locationY(?value:Float, ?add:Bool):Float {
		if (value != null) add ? location.y += value : location.y = value;
		return location.y;
	}
	
	public function locationZ(?value:Float, ?add:Bool):Float {
		if (value != null) add ? location.z += value : location.z = value;
		return location.z;
	}
	
	public function scaleAll(x:Float, y:Float, z:Float, ?add:Bool):IDisplay3D {
		scaleX(x,add);
		scaleY(y,add);
		scaleZ(z,add);
		return this;
	}
	
	public function transform(x:Float, y:Float, z:Float, x1:Float, y1:Float, z1:Float, w:Float, h:Float, d:Float):IDisplay {
		return moveTo(x, y, z).rotateAll(x1, y1, z1).scaleAll(w, h, d);
	}
	
	public function scaleX(?value:Float, ?add:Bool):Float {
		if (value != null) add ? scale.x += value : scale.x = value;
		return scale.x;
	}
	
	public function scaleY(?value:Float, ?add:Bool):Float {
		if (value != null) add ? scale.y += value : scale.y = value;
		return scale.y;
	}
	
	public function scaleZ(?value:Float, ?add:Bool):Float {
		if (value != null) add ? scale.z += value : scale.z = value;
		return scale.z;
	}
	
	public function update():IDisplay {
		if (this.perspective != null) xcss.write("perspective", this.perspective);
		if (this.transformOrigin != null) xcss.write("transformOrigin", this.transformOrigin);
		if (this.transformStyle != null) xcss.write("transformStyle", this.transformStyle);
		if (this.backFace != null) xcss.write("backfaceVisibility", this.backFace);
		xcss.write("transform", "rotateX(" + rotation.x + "deg) rotateY(" + rotation.y + "deg) rotateZ(" + rotation.z + "deg) translate3d(" + location.x + "px," + location.y + "px," + location.z + "px) scale3d(" + scale.x + "," + scale.y + "," + scale.z + ")");
		xcss.apply(this);
		return this;
	}
	
	public function doubleSided(value:Bool):IDisplay3D {
		backFace = value ? "visible" : "hidden";
		return this;
	}
	
	public function flipHorizontal():IDisplay3D {
		rotationY(180, true);
		return this;
	}
	
	public function flipVertical():IDisplay3D {
		rotationX(180, true);
		return this;
	}
	
}