package sirius.dom;
import js.Browser;
import js.html.CanvasElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Canvas")
class Canvas extends Display {
	
	static public function get(q:String):Canvas {
		return cast Sirius.one(q);
	}
	
	public var paper:CanvasElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createCanvasElement();
		super(q, null);
		paper = cast element;
	}
	
}