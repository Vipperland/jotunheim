package sirius.dom;
import js.Browser;
import js.html.StyleElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Style")
class Style extends Display {
	
	public var object:StyleElement;
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createStyleElement();
		super(q, null, d);
		object = cast element;
		object.type = "text/css";
	}
	
	public function publish():Void {
		Browser.document.head.appendChild(cast element);
	}
	
}