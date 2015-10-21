package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.DataList")
class DataList extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):DataList {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createDataListElement();
		super(q,null);
	}
	
}