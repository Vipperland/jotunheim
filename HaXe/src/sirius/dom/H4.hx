package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.H4")
class H4 extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):H4 {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createElement("h4");
		super(q,null);
	}
	
}