package sirius.dom;
import js.Browser;
import js.html.StyleElement;
import sirius.dom.IDisplay;

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
			write(Sirius.resources.get(q, data), true);
		else
			write('/* <!> mod:' + q + ' not found */');
		return this;
	}
	
}