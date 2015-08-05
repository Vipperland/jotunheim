package sirius.dom;
import js.Browser;
import js.html.Element;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Body")
class Body extends Display {

	public function new(?q:Element, ?d:String = null) {
		if (q == null) q = Browser.document.createBodyElement();
		super(q,null,d);
	}
	
	public function enlarge(?scroll:String = "over-hid"):Body {
		this.css("wh-100pc" + (scroll != null ? " " + scroll : "") + " padd-0 marg-0 pos-abs");
		return this;
	}
	
}