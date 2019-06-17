package jotun.dom;
import jotun.Jotun;
import jotun.css.XCode;
import jotun.css.XCSS;
import jotun.dom.IDisplay;
import jotun.math.ITransform3D;
import jotun.math.Transform3D;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.dom.Display3D")
class Display3D extends Display implements IDisplay3D {
	
	static public function get(q:String):Display3D {
		return cast Jotun.one(q);
	}
	
	static private var _fixed:Bool = false;
	
	static private function _backface_fix():Void {
		if(!_fixed){
			_fixed = true;
			XCode.style('[sru-dom="display3d"]', 'transform-style:' + (Jotun.agent.edge ? 'flat' : 'preserve-3d') + ';backface-visibility:inherit;');
			XCode.apply();
		}
	}
	
	public var info:Dynamic;
	
	public var xcss:XCSS;
	
	public var transformData:ITransform3D;
	
	public function new(?q:Dynamic) {
		super(q);
		_backface_fix();
		xcss = new XCSS();
		transformData = new Transform3D();
		if (q == null){
			attribute('sru-dom', 'display3d');
		}
		render();
	}
	
	public function preserve3d():IDisplay3D {
		transformData.transformStyle = "preserve-3d";
		return this;
	}
	
	public function setPerspective(value:String, ?origin:String):IDisplay3D {
		if (value != null)
			transformData.perspective = value;
		if (origin != null)
			transformData.transformOrigin = origin;
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
			add ? transformData.rotation.x += value : transformData.rotation.x = value;
		}
		return transformData.rotation.x;
	}
	
	public function rotationY(?value:Float, ?add:Bool):Float {
		if (value != null) {
			add ? transformData.rotation.y += value : transformData.rotation.y = value;
		}
		return transformData.rotation.y;
	}
	
	public function rotationZ(?value:Float, ?add:Bool):Float {
		if (value != null) {
			add ? transformData.rotation.z += value : transformData.rotation.z = value;
		}
		return transformData.rotation.z;
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
			add ? transformData.location.x += value : transformData.location.x = value;
		return transformData.location.x;
	}
	
	public function locationY(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transformData.location.y += value : transformData.location.y = value;
		return transformData.location.y;
	}
	
	public function locationZ(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transformData.location.z += value : transformData.location.z = value;
		return transformData.location.z;
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
			add ? transformData.scale.x += value : transformData.scale.x = value;
		return transformData.scale.x;
	}
	
	public function scaleY(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transformData.scale.y += value : transformData.scale.y = value;
		return transformData.scale.y;
	}
	
	public function scaleZ(?value:Float, ?add:Bool):Float {
		if (value != null)
			add ? transformData.scale.z += value : transformData.scale.z = value;
		return transformData.scale.z;
	}
	
	public function render():IDisplay {
		if (transformData.perspective != null)
			xcss.write("perspective", transformData.perspective);
		if (transformData.transformOrigin != null)
			xcss.write("transformOrigin", transformData.transformOrigin);
		if (transformData.transformStyle != null)
			xcss.write("transformStyle", transformData.transformStyle);
		if (transformData.backFace != null)
			xcss.write("backfaceVisibility", transformData.backFace);
		xcss.write("transform", "rotateX(" + transformData.rotation.x + "deg) rotateY(" + transformData.rotation.y + "deg) rotateZ(" + transformData.rotation.z + "deg) translate3d(" + transformData.location.x + "px," + transformData.location.y + "px," + transformData.location.z + "px) scale3d(" + transformData.scale.x + "," + transformData.scale.y + "," + transformData.scale.z + ")");
		xcss.apply(this);
		return this;
	}
	
	public function doubleSided(value:Bool):IDisplay3D {
		transformData.backFace = value ? "visible" : "hidden";
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