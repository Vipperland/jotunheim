package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.FormElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Form")
class Form extends Display {
	
	static public function get(q:String):Form {
		return cast Jotun.one(q);
	}
	
	public var object:FormElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createFormElement();
		super(q, null);
		object = cast element;
	}
	
	public function submit():Void {
		object.submit();
	}
	
}