package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.TR")
class TR extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):TR {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createTableRowElement();
		super(q,null,d);
	}
	
}