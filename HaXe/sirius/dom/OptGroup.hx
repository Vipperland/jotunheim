package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.OptGroup")
class OptGroup extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):OptGroup {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createOptGroupElement();
		super(q,null,d);
	}
	
}