package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Label")
class Label extends Display {
	
	static public function get(q:String):Label {
		return cast Sirius.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createLabelElement();
		super(q,null);
	}
	
}