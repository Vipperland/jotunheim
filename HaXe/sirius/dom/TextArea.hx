package sirius.dom;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.TextArea")
class TextArea extends Input {
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createTextAreaElement();
		super(q, d);
	}
	
}