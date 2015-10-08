package sirius.dom;
import js.Browser;
import js.html.Element;
import sirius.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Div")
class Div extends Display {
	
	public static function get(q:String, ?h:IDisplay->Void):Div {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Element, ?d:String = null) {
		if (q == null) q = Browser.document.createDivElement();
		super(q, null, d);
	}
	
}