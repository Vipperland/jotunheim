package jotun.dom;
import jotun.Jotun;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_H1")
class H1 extends Display{
	
	static public function get(q:String):H1 {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createElement("h1");
		super(q,null);
	}
	
}