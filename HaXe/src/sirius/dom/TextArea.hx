package sirius.dom;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.TextArea")
class TextArea extends Input {
	
	static public function get(q:String):TextArea {
		return cast Sirius.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createTextAreaElement();
		super(q);
	}
	
}