package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Meta")
class Meta extends Display {
	
	public static function get(q:String, ?h:IDisplay->Void):Meta {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createMetaElement();
		super(q,null,d);
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