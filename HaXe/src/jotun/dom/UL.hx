package jotun.dom;
import jotun.Jotun;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_UL")
class UL extends Display{
	
	static public function get(q:String):UL {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createUListElement();
		super(q,null);
	}
	
}