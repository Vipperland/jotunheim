package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Base")
class Base extends Display{

	public static function get(q:String, ?h:IDisplay->Void):Base {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createBaseElement();
		super(q,null);
	}
	
}