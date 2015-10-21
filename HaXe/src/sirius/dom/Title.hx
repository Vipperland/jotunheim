package sirius.dom;
import js.Browser;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Title")
class Title extends Display{
	
	public static function get(q:String, ?h:IDisplay->Void):Title {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createTitleElement();
		super(q,null);
	}
	
}