package jotun.dom;
import jotun.Jotun;
import jotun.utils.Dice;
import js.Browser;
import jotun.events.IEvent;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_A")
class A extends Display {
	
	static public function get(q:String):A {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createAnchorElement();
		super(q,null);
	}
	
	public function href(?url:String):String {
		if(url != null)
			attribute('href', url);
		return attribute('href');
	}
	
	public function link():Dynamic {
		var uri = {};
		Dice.Values(['href', 'protocol', 'host', 'hostname', 'port', 'pathname', 'search', 'hash'], function(v:String){
			Reflect.setField(uri, v, Reflect.field(element, v));
		});
		return uri;
	}
	
	public function target(?q:String):String {
		if(q != null)
			attribute('target', q);
		return attribute('target');
	}
	
}