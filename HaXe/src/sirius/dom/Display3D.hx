package sirius.dom;
import haxe.Log;
import js.Browser;
import js.html.Point;
import sirius.css.Automator;
import sirius.css.XCSS;
import sirius.dom.IDisplay;
import sirius.math.ITransform3D;
import sirius.math.Point3D;
import sirius.math.Transform3D;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Display3D")
class Display3D extends Div implements IDisplay3D {
	
	static public function get(q:String):Display3D {
		return cast Sirius.one(q);
	}
	
	static private var _fixed:Bool = false;
	
	static private function _backface_fix():Void {
		if(!_fixed){
			_fixed = true;
			Automator.build("backface-visibility-inherit transform-style-inherit", "*");
		}
	}
	
	public var info:Dynamic;
	
	public var xcss:XCSS;
	
	public var transform:ITransform3D;
	
	public function new(?q:Dynamic) {
		super(q);
		_backface_fix();
		xcss = new XCSS();
		transform = new Transform3D();
		attribute('sru-dom', 'display3d');
		update();
	}
	
	public function preserve3d():IDisplay3D {
		transform.transformStyle = "preserve-3d";
		return this;
	}
	
	public function setPerspective(value:String, ?origin:String):IDisplay3D {
		if (value != null)
			transform.perspective = value;
		if (origin != null)
			transform.transformOrigin = origin;
		return this;
	}
	
	public function rotateAll(x:Float, y:Float, ?z:Float, ?add:Bool):IDisplay3D {
		rotationX(x, add);
		rotationY(y, add);
		if (z != null)
			rotationZ(z, add);
		return this;
	}
	
	public function rotationX(?value:Float, ?add:Bool):Float {
		if (value != null) {
			add ? transform.rotation.x += value : transform.rotation.x = value;
			if (transform.rotation.x < -180)
				transform.rotation.x += 360;
			else if (transform.rotation.x > 180)
				transform.rotation.x -= 360;
		}
		return transform.rotation.x;
	}
	
	public function rotationY(?value:Float, ?add:Bool):Float {
		if (value != null) {
			add ? transform.rotation.y += value : transform.rotation.y = value;
			if (transform.rotation.y < -180)
				transform.rotation.y += 360;
			else if (transform.rotation.y > 180)
				transform.rotation.y -= 360;
		}
		return transform.rotation.y;
	}
	
	public function rotationZ(?value:Float, ?add:Bool):Float {
		if (value != null) {
			add ? transform.rotation.z += value : transform.rotation.z = value;
			if (transform.rotation.z < -180)
				transform.rotation.z += 360;
			else if (transform.rotation.z > 180)
				transform.rotation.z -= 360;
		}
		return transform.rotation.z;
	}
	
	public function moveTo(x:Float, y:Float, ?z:Float, ?add:Bool):IDisplay3D {
		locationX(x,add);
		locationY(y, add);
		if (z != null)
			locationZ(z,add);
		return this;
	}
	
	public function locationX(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transform.location.x += value : transform.location.x = value;
		return transform.location.x;
	}
	
	public function locationY(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transform.location.y += value : transform.location.y = value;
		return transform.location.y;
	}
	
	public function locationZ(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transform.location.z += value : transform.location.z = value;
		return transform.location.z;
	}
	
	public function scaleAll(x:Float, y:Float, ?z:Float, ?add:Bool):IDisplay3D {
		scaleX(x,add);
		scaleY(y,add);
		if (z != null)
			scaleZ(z,add);
		return this;
	}
	
	public function transform2D(x:Float, y:Float, x1:Float, y1:Float, w:Float, h:Float):IDisplay {
		return moveTo(x, y, null).rotateAll(x1, y1, null).scaleAll(w, h, null);
	}
	
	public function transform3D(x:Float, y:Float, z:Float, x1:Float, y1:Float, z1:Float, w:Float, h:Float, d:Float):IDisplay {
		return moveTo(x, y, z).rotateAll(x1, y1, z1).scaleAll(w, h, d);
	}
	
	public function scaleX(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transform.scale.x += value : transform.scale.x = value;
		return transform.scale.x;
	}
	
	public function scaleY(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transform.scale.y += value : transform.scale.y = value;
		return transform.scale.y;
	}
	
	public function scaleZ(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transform.scale.z += value : transform.scale.z = value;
		return transform.scale.z;
	}
	
	public function update():IDisplay {
		if (transform.perspective != null)
			xcss.write("perspective", transform.perspective);
		if (transform.transformOrigin != null)
			xcss.write("transformOrigin", transform.transformOrigin);
		if (transform.transformStyle != null)
			xcss.write("transformStyle", transform.transformStyle);
		if (transform.backFace != null)
			xcss.write("backfaceVisibility", transform.backFace);
		xcss.write("transform", "rotateX(" + transform.rotation.x + "deg) rotateY(" + transform.rotation.y + "deg) rotateZ(" + transform.rotation.z + "deg) translate3d(" + transform.location.x + "px," + transform.location.y + "px," + transform.location.z + "px) scale3d(" + transform.scale.x + "," + transform.scale.y + "," + transform.scale.z + ")");
		xcss.apply(this);
		return this;
	}
	
	public function doubleSided(value:Bool):IDisplay3D {
		transform.backFace = value ? "visible" : "hidden";
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