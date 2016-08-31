package sirius.dom;
import js.Browser;
import js.html.Element;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Div")
class Div extends Display {
	
	static public function get(q:String):Div {
		return cast Sirius.one(q);
	}
	
	public function new(?q:Element) {
		if (q == null) q = Browser.document.createDivElement();
		super(q, null);
	}
	
}