package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.CanvasElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.Canvas")
class Canvas extends Display {
	
	static public function get(q:String):Canvas {
		return cast Jotun.one(q);
	}
	
	public var dom:CanvasElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createCanvasElement();
		super(q, null);
		dom = cast element;
	}
	
}