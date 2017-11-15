package sirius.dom;
import js.Browser;
import js.html.StyleElement;
import sirius.dom.IDisplay;
import sirius.events.IEvent;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Style")
class Style extends Display {
	
	static public function get(q:String):Style {
		return cast Sirius.one(q);
	}
	
	static public function require(url:Dynamic, handler:Dynamic) {
		if (url.length > 0) {
			var file:String = url.shift();
			if (file != null) {
				var s:Link = new Link();
				s.href(file, function(e:IEvent) {
					Style.require(url, handler);
				});
				Sirius.document.head.addChild(s);
			}
		}else if(handler != null){
			handler();
		}
	}
	
	public var object:StyleElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createStyleElement();
		super(q, null);
		object = cast element;
		object.type = "text/css";
	}
	
	public function publish():Void {
		Browser.document.head.appendChild(cast element);
	}
	
	override public function mount(q:String, ?data:Dynamic, ?at:Int = -1):IDisplay {
		if (Sirius.resources.exists(q))
			writeHtml(Sirius.resources.get(q, data));
		else
			writeHtml('/* <!> mod:' + q + ' not found */');
		return this;
	}
	
}