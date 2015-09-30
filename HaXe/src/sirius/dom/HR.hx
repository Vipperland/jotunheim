package sirius.dom;
import js.Browser;
import js.html.BaseElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.HR")
class HR extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):HR {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createHRElement();
		super(q,null,d);
	}
	
}