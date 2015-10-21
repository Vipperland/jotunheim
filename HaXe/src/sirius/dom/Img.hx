package sirius.dom;
import js.Browser;
import js.html.ImageElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Img")
class Img extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Img {
		return cast Sirius.one(q,null,h);
	}
	
	public var object:ImageElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createImageElement();
		super(q, null);
		object = cast element;
	}
	
	public function src(?value:String):String {
		var a:ImageElement;
		if (value != null) object.src = value;
		return object.src;
	}
	
	public function alt(?value:String):String {
		if (value != null) object.alt = value;
		return object.alt;
	}
	
}