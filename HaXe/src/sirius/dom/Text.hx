package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Text extends Display {
	
	static public function get(q:String):Text {
		return cast Sirius.one(q);
	}
	
	public function new(?q:Dynamic) {
		q = Browser.document.createTextNode(q);
		super(q, null);
	}
	
}