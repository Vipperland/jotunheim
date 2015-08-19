package sirius.dom;
import js.Browser;
import js.html.CanvasElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Canvas")
class Canvas extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Canvas {
		return cast Sirius.one(q,null,h);
	}
	
	public var paper:CanvasElement;
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createCanvasElement();
		super(q, null, d);
		paper = cast element;
	}
	
}