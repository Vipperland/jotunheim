package jotun.dom;
import jotun.Jotun;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Meta")
class Meta extends Display {
	
	static public function get(q:String):Meta {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createMetaElement();
		super(q,null);
	}
	
	public function set(name:String, content:String):Void {
		attribute('name', name);
		attribute('content', content);
	}
	
	public function charset(q:String, ?vr:Int=5):Void {
		if (vr >= 5) { 
			attribute('charset', q); 
		}else if (vr < 5) {
			attribute('http-equiv', 'content-type');
			attribute('charset', 'text/html; charset=UTF-8');
		}
	}
	
}