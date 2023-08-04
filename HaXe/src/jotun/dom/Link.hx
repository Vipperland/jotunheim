package jotun.dom;
import jotun.Jotun;
import jotun.tools.Utils;
import js.Browser;
import js.html.Blob;
import js.html.LinkElement;
import jotun.events.IEvent;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Link")
class Link extends Display{
	
	static public function get(q:String):Link {
		return cast Jotun.one(q);
	}
	
	static public function fromBlob(blob:Blob):Link {
		var s:Link = new Link();
		s.href(Utils.fileToURL(blob));
		return s;
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createLinkElement();
		super(q, null);
	}
	
	public function href(url:String, ?handler:IEvent->Void):String {
		if(url != null){
			cast(element, LinkElement).href = url;
			if (handler != null) {
				events.load(handler, 1);
			}
			return url;
		}else{
			return cast(element, LinkElement).href;
		}
		
	}
	
}