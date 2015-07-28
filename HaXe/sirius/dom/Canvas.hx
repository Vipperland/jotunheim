package sirius.dom;
import js.Browser;
import js.html.CanvasElement;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.dom.Canvas")
class Canvas extends Display{

	public var paper:CanvasElement;
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createCanvasElement();
		super(q, null, d);
		paper = cast Self;
	}
	
}