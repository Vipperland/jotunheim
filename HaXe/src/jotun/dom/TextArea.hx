package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.TextAreaElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.TextArea")
class TextArea extends Input {
	
	static public function get(q:String):TextArea {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createTextAreaElement();
		super(q);
	}
	
}