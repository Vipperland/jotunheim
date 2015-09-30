package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.H5")
class H5 extends Display {

	public static function get(q:String, ?h:IDisplay->Void):H5 {
		return cast Sirius.one(q,null,h);
	}

	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createElement("h5");
		super(q,null,d);
	}
	
}