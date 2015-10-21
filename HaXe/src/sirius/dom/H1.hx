package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.H1")
class H1 extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):H1 {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createElement("h1");
		super(q,null);
	}
	
}