package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.OptGroup")
class OptGroup extends Display{
	
	static public function get(q:String):OptGroup {
		return cast Sirius.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createOptGroupElement();
		super(q,null);
	}
	
}