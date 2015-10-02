package sirius.dom;
import js.Browser;
import js.html.IFrameElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.IFrame")
class IFrame extends Display {
	
	public var object:IFrameElement;
	
	public static function get(q:String, ?h:IDisplay->Void):IFrame {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createIFrameElement();
		super(q, null, d);
		object = cast element;
	}
	
	public function src(url:String):Void {
		object.src = url;
	}
	
	public function noScroll():Void {
		object.scrolling = 'no';
	}
	
}