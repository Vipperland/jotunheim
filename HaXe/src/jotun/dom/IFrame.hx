package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.IFrameElement;
import js.html.Location;
import js.html.Window;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.IFrame")
class IFrame extends Display {
	
	static public function get(q:String):IFrame {
		return cast Jotun.one(q);
	}
	
	public var object:IFrameElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createIFrameElement();
		super(q, null);
		object = cast element;
	}
	
	public function src(url:String):Void {
		object.src = url;
	}
	
	public function enableScroll(mode:Bool):Void {
		object.scrolling = mode ? 'yes' : 'no';
	}
	
}