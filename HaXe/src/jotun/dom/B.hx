package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.BaseElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.dom.B")
class B extends Display{
	
	static public function get(q:String):B {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createElement("B");
		super(q,null);
	}
	
}