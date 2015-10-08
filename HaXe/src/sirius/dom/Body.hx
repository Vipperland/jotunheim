package sirius.dom;
import js.Browser;
import js.html.BodyElement;
import js.html.Element;
import js.html.Event;
import sirius.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Body")
class Body extends Display {
	
	private var _body:BodyElement;
	
	public static function get(q:String, ?h:IDisplay->Void):Body {
		return cast Sirius.one(q,null,h);
	}

	public function new(?q:Element, ?d:String = null) {
		if (q == null) q = Browser.document.createBodyElement();
		super(q, null, d);
		_body = cast this.element;
		Browser.window.addEventListener('resize', _wResize);
	}
	
	private function _wResize(e:Event):Void {
		events.resize().call();
	}
	
	public function enlarge(?scroll:String = "over-hid"):Body {
		this.css("w-100pc h-100pc" + (scroll != null ? " " + scroll : "") + " padd-0 marg-0 pos-abs");
		return this;
	}
	
	public function maxScrollX():Int {
		return _body.scrollWidth - Utils.viewportWidth();
	}
	
	public function maxScrollY():Int {
		return _body.scrollHeight - Utils.viewportHeight();
	}
	
}