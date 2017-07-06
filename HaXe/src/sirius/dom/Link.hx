package sirius.dom;
import js.Browser;
import js.html.LinkElement;
import sirius.events.IEvent;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Link")
class Link extends Display{
	
	static public function get(q:String):Link {
		return cast Sirius.one(q);
	}
	
	public var object:LinkElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createLinkElement();
		super(q, null);
		object = cast element;
	}
	
	public function href(url:String, ?handler:IEvent->Void):Void {
		object.href = url;
		if (handler != null) events.load(handler, 1);
	}
	
}