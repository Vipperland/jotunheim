package jotun.dom;
import jotun.Jotun;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_BR")
class BR extends Display{

	static public function get(q:String):BR {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createBRElement();
		super(q,null);
	}
	
}