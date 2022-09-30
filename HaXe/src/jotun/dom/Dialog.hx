package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.Element;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Dialog")
class Dialog extends Display {
	
	static public function get(q:String):Div {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Element) {
		if (q == null) q = Browser.document.createElement('dialog');
		super(q, null);
	}
	
	public function showModal():IDisplay {
		Reflect.field(cast element, 'showModal')();
		return this;
	}
	
	public function showDialog():IDisplay {
		Reflect.field(cast element, 'show')();
		return this;
	}
	
}