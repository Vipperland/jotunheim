package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.BaseElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_HR")
class HR extends Display{
	
	static public function get(q:String):HR {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createHRElement();
		super(q,null);
	}
	
}