package sirius.dom;
import js.Browser;
import js.html.BaseElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.I")
class I extends Display{

	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createElement("I");
		super(q,null,d);
	}
	
}