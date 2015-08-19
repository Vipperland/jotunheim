package sirius.dom;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.TextArea")
class TextArea extends Input {
	
	public static function get(q:String, ?h:IDisplay->Void):TextArea {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createTextAreaElement();
		super(q, d);
	}
	
}